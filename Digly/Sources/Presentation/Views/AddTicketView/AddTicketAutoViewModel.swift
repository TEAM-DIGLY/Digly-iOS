import SwiftUI
import Combine

@MainActor
class AddTicketAutoViewModel: ObservableObject {
    @Published var ticketText: String = ""
    @Published var isLoading: Bool = false
    @Published var extractedData: CreateTicketFormData?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupTextMonitoring()
    }
    
    private func setupTextMonitoring() {
        $ticketText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                // 실시간 텍스트 변경 처리 로직
                self?.validateInput(text)
            }
            .store(in: &cancellables)
    }
    
    private func validateInput(_ text: String) {
        // 입력 텍스트 검증 로직
        if text.count > 1000 {
            errorMessage = "텍스트가 너무 깁니다. 1000자 이하로 입력해주세요."
        } else {
            errorMessage = nil
        }
    }
    
    func processTicketText(onSuccess: @escaping (CreateTicketFormData) -> Void) {
        Task {
            isLoading = true
            let parser = TicketInfoParser()
            let result = parser.parseTicketInfo(from: ticketText)
            try await Task.sleep(nanoseconds: 1_200_000_000)
            switch result {
            case .success(let data):
                extractedData = data
                isLoading = false
                onSuccess(data)
            case .failure(let error):
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
