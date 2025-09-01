import SwiftUI
import Combine

enum DateTimeStep: CaseIterable {
    case date
    case time
    
    var labelText: String {
        switch self {
        case .date:
            return "관람 일자"
        case .time:
            return "관람 시간"
        }
    }
}

@MainActor
final class CreateTicketViewModel: ObservableObject {
    @Published var currentStep: CreateTicketStep = .title
    @Published var formData = CreateTicketFormData()
    @Published var isLoading: Bool = false
    @Published var dateTimeStep: DateTimeStep = .date
    @Published var titleSearchResults: [String] = []
    
    private let venueOptions = ["샤롯데씨어터", "세종문화회관", "예술의전당", "블루스퀘어", "LG아트센터", "충무아트센터", "국립극장"]
    
    private let crawlingUseCase: CrawlingUseCase
    private let ticketUseCase: TicketUseCase
    private var cancellables = Set<AnyCancellable>()
    private var titleSearchTask: Task<Void, Never>? = nil
    
    init(
        crawlingUseCase: CrawlingUseCase = CrawlingUseCase(crawlingRepository: CrawlingRepository()),
        ticketUseCase: TicketUseCase = TicketUseCase(ticketRepository: TicketRepository())
    ) {
        self.crawlingUseCase = crawlingUseCase
        self.ticketUseCase = ticketUseCase
        setupTitleSearchObserver()
    }
    
    var progressPercentage: CGFloat {
        return CGFloat(currentStep.progressPercentage)
    }
    
    var isNextButtonEnabled: Bool {
        switch currentStep {
        case .title:
            return !formData.showName.isEmpty
        case .dateTime:
            return formData.isDateTimeValid
        case .venue:
            return !formData.venueName.isEmpty
        case .ticketDetails:
            return formData.isBasicInfoComplete
        }
    }
    
    var showOptionsForCurrentStep: [String] {
        switch currentStep {
        case .title:
            return titleSearchResults
        case .venue:
            return venueOptions
        default:
            return []
        }
    }
    
    func moveToNextStep() {
        guard isNextButtonEnabled else { return }
        
        if currentStep == .ticketDetails {
            // Final step - submit ticket
            submitTicket()
        } else {
            proceedToNextStep()
        }
    }
    
    private func proceedToNextStep() {
        let allCases = CreateTicketStep.allCases
        guard let currentIndex = allCases.firstIndex(of: currentStep),
              currentIndex < allCases.count - 1 else { return }
        
        currentStep = allCases[currentIndex + 1]
    }
    
    func moveToPreviousStep() {
        let allCases = CreateTicketStep.allCases
        guard let currentIndex = allCases.firstIndex(of: currentStep),
              currentIndex > 0 else { return }
        
        currentStep = allCases[currentIndex - 1]
    }
    
    func setFieldBinding(for step: CreateTicketStep) -> Binding<String> {
        Binding(
            get: { self.formData.value(for: step) },
            set: { newValue in
                self.formData.setValue(newValue, for: step)
            }
        )
    }
    
    func updateTitle(_ show: String) {
        formData.showName = show
    }
    
    func updateVenueSelection(_ venue: String) {
        formData.venueName = venue
    }
    
    func updateDate(_ date: String) {
        formData.setDate(date)
    }
    
    func updateTime(_ time: String) {
        formData.setTime(time)
    }
    
    func updateSeatNumber(_ seat: String) {
        formData.setSeatNumber(seat)
    }
    
    func updateSeatLocation(_ location: String) {
        formData.setSeatLocation(location)
    }
    
    func updateTicketPrice(_ price: String) {
        formData.setTicketPrice(price)
    }
    
    func getFormattedShowName() -> String {
        return formData.showName.isEmpty ? "(뮤지컬명)" : formData.showName
    }
    
    func setDateTimeFieldBinding(for step: DateTimeStep) -> Binding<String> {
        switch step {
        case .date:
            return Binding(
                get: { self.formData.selectedDate },
                set: { newValue in
                    self.formData.setDate(newValue)
                }
            )
        case .time:
            return Binding(
                get: { self.formData.selectedTime },
                set: { newValue in
                    self.formData.setTime(newValue)
                }
            )
        }
    }
    
    private func setupTitleSearchObserver() {
        $formData
            .map { $0.showName }
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.performTitleSearch(query: text)
            }
            .store(in: &cancellables)
    }
    
    private func performTitleSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            titleSearchResults = []
            return
        }
        
        titleSearchTask?.cancel()
        titleSearchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let results = try await self.crawlingUseCase.searchTicketTitles(query: trimmed)
                await MainActor.run {
                    self.titleSearchResults = results
                }
            } catch {
                await MainActor.run {
                    self.titleSearchResults = []
                }
            }
        }
    }
    
    private func submitTicket() {
        isLoading = true
        
        Task {
            do {
                let performanceDate = try parsePerformanceDateTime(
                    dateString: formData.selectedDate,
                    timeString: formData.selectedTime
                )
                
                let seatNumberValue: String? = formData.seatLocation.isEmpty ? nil : formData.seatLocation
                let priceValue: Int32? = Int32(formData.ticketPrice.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: ""))
                
                let ticket = try await ticketUseCase.createTicket(
                    name: formData.showName,
                    performanceTime: performanceDate,
                    place: formData.venueName,
                    count: Int32(formData.seatNumber) ?? 1,
                    seatNumber: seatNumberValue,
                    price: priceValue,
                    colors: [],
                    feelings: []
                )
                
                await MainActor.run {
                    self.isLoading = false
                    ToastManager.shared.show(.success("티켓이 생성되었습니다."))
                    print("티켓 생성 완료: \(ticket)")
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    ToastManager.shared.show(.error(error))
                    print("티켓 생성 실패: \(error)")
                }
            }
        }
    }
    
    private func parsePerformanceDateTime(dateString: String, timeString: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        let combined = "\(dateString) \(timeString)"
        if let date = dateFormatter.date(from: combined) {
            return date
        }
        
        // 폴백: 각각 파싱 후 캘린더로 합치기
        let dF = DateFormatter()
        dF.dateFormat = "yyyy.MM.dd"
        let tF = DateFormatter()
        tF.dateFormat = "HH:mm"
        guard let d = dF.date(from: dateString), let t = tF.date(from: timeString) else {
            throw NSError(domain: "CreateTicket", code: 0, userInfo: [NSLocalizedDescriptionKey: "날짜/시간 형식이 올바르지 않습니다."])
        }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: d)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: t)
        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
        return calendar.date(from: merged) ?? d
    }
}
