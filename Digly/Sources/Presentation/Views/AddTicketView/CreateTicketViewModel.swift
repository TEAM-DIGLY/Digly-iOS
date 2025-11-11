import SwiftUI
import Combine

enum DateTimeStep: String, CaseIterable {
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
    @Published var formData = CreateTicketFormData()
    
    @Published var currentStep: CreateTicketStep = .title
    @Published var dateTimeStep: DateTimeStep = .date
    
    /// - Note: 크롤링 api 호출 시, 자동완성 검색결과를 보여주기 위한 상태변수입니다.
    @Published var searchResults: [String] = []
    
    @Published var isLoading: Bool = false
    
    private let crawlingUseCase: CrawlingUseCase
    private let ticketUseCase: TicketUseCase
    private var cancellables = Set<AnyCancellable>()
    private var titleSearchTask: Task<Void, Never>? = nil
    private var venueSearchTask: Task<Void, Never>? = nil
    
    var onTicketCreated: ((CreateTicketFormData) -> Void)?
    
    init(
        crawlingUseCase: CrawlingUseCase = CrawlingUseCase(crawlingRepository: CrawlingRepository()),
        ticketUseCase: TicketUseCase = TicketUseCase(ticketRepository: TicketRepository()),
        onTicketCreated: ((CreateTicketFormData) -> Void)? = nil
    ) {
        self.crawlingUseCase = crawlingUseCase
        self.ticketUseCase = ticketUseCase
        self.onTicketCreated = onTicketCreated
        setupTitleSearchObserver()
        setupVenueSearchObserver()
    }
    
    var progressPercentage: CGFloat {
        return CGFloat(currentStep.progressPercentage)
    }
    
    var isNextButtonEnabled: Bool {
        switch currentStep {
        case .title:
            return !formData.showName.isEmpty
        case .dateTime:
            return formData.date != nil && formData.time != nil
        case .venue:
            return !formData.place.isEmpty
        case .ticketDetails:
            return formData.isBasicInfoComplete
        }
    }
    
    
    func moveToNextStep() {
        guard isNextButtonEnabled else { return }

        if currentStep == .ticketDetails {
            submitTicket()
        } else {
            proceedToNextStep()
        }
    }
    
    private func proceedToNextStep() {
        let allCases = CreateTicketStep.allCases
        guard let currentIndex = allCases.firstIndex(of: currentStep),
              currentIndex < allCases.count - 1 else { return }
        searchResults = []
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
    
    func updateValueOf(_ type: CreateTicketStep, _ value: String) {
        formData.setValue(value, for: type)
    }
    
    func updateSeatNumber(_ seat: String) {
        formData.setSeatNumber(seat)
    }
    
    func updateSeatLocation(_ location: String) {
        formData.setSeatNumber(location)
    }
    
    func updateTicketPrice(_ price: Int) {
        formData.setTicketPrice(price)
    }
    
    func setDateTimeFieldBinding(for step: DateTimeStep) -> Binding<Date> {
        switch step {
        case .date:
            return Binding(
                get: { self.formData.date ?? Date() },
                set: { newValue in
                    self.formData.updateDate(from: newValue)
                }
            )
        case .time:
            return Binding(
                get: {
                    if let time = self.formData.time { return time }
                    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                    components.hour = 15
                    components.minute = 0
                    return Calendar.current.date(from: components) ?? Date()
                },
                set: { newValue in
                    self.formData.updateTime(from: newValue)
                }
            )
        }
    }
    
    private func submitTicket() {
        Task {
            do {
                isLoading = true
                guard let performanceDateTime = formData.combinedPerformanceDateTime else {
                    isLoading = false
                    ToastManager.shared.show(.errorWithMessage("관람 일시가 올바르지 않습니다."))
                    return
                }
                _ = try await ticketUseCase.createTicket(
                    name: formData.showName,
                    time: performanceDateTime,
                    place: formData.place,
                    count: formData.count,
                    seatNumber: formData.seatNumber,
                    price: formData.price,
                    emotions: [] // TODO: EmotionColor 선택 기능 추가 시 수정
                )
                isLoading = false
                ToastManager.shared.show(.success("티켓이 생성되었습니다."))
                
                // Navigate to EndCreateTicketView
                onTicketCreated?(formData)
            } catch {
                isLoading = false
                ToastManager.shared.show(.error(error))
                print("티켓 생성 실패: \(error)")
            }
        }
    }
}

extension CreateTicketViewModel {
    private func setupTitleSearchObserver() {
        $formData
            .map { $0.showName }
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.handleTitleTextChange(query: text)
            }
            .store(in: &cancellables)
    }
    
    private func setupVenueSearchObserver() {
        $formData
            .map { $0.place }
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.handleVenueTextChange(query: text)
            }
            .store(in: &cancellables)
    }
    
    private func handleTitleTextChange(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            do {
                isLoading = true
                searchResults = try await crawlingUseCase.searchTicketTitles(query: trimmed)
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("제목 검색"))
            }
        }
    }

    private func handleVenueTextChange(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            do {
                isLoading = true
                searchResults = try await crawlingUseCase.searchTicketPlaces(query: trimmed)
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("제목 검색"))
            }
        }
    }
}
