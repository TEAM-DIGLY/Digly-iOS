import SwiftUI
import Combine

@MainActor
class TicketAutoInputViewModel: ObservableObject {
    @Published var ticketText: String = ""
    @Published var isProcessing: Bool = false
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
    
    func extractTicketInfo() {
        guard !ticketText.isEmpty else { return }
        
        isProcessing = true
        
        // 시뮬레이션: 실제로는 API 호출 또는 텍스트 파싱 로직
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.processTicketText()
        }
    }
    
    private func processTicketText() {
        let parser = TicketInfoParser()
        let result = parser.parseTicketInfo(from: ticketText)
        
        switch result {
        case .success(let data):
            extractedData = data
            isProcessing = false
            // 추출 완료 후 다음 화면으로 이동하는 로직 추가 예정
        case .failure(let error):
            errorMessage = error.localizedDescription
            isProcessing = false
        }
    }
}