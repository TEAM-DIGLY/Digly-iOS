import SwiftUI
import Combine

@MainActor
final class EndCreateTicketViewModel: ObservableObject {
    @Published var ticketData: CreateTicketFormData
    
    private let ticketUseCase: TicketUseCase
    
    init(
        ticketData: CreateTicketFormData,
        ticketUseCase: TicketUseCase = TicketUseCase(ticketRepository: TicketRepository())
    ) {
        self.ticketData = ticketData
        self.ticketUseCase = ticketUseCase
    }
    
    // MARK: - Computed Properties
    
    var formattedDate: String {
        guard let date = ticketData.date else { return "관람일" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E) HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: ticketData.combinedPerformanceDateTime ?? date)
    }
    
    var formattedViewingCount: String {
        "#\(ticketData.seatNumber)번째 관람"
    }
    
    var formattedPrice: String {
        return "\(ticketData.price)원"
    }
    
    var formattedSeatLocation: String {
        ticketData.seatNumber.isEmpty ? "좌석 정보 없음" : ticketData.seatNumber
    }
    
    // MARK: - Navigation Actions
    
    func navigateToAddFeeling() {
        // Navigation will be handled by the parent view
        // This function serves as a placeholder for the navigation logic
    }
    
    func navigateToEditTicket() {
        // Navigation will be handled by the parent view
        // This function serves as a placeholder for the navigation logic
    }
    
    func navigateToComplete() {
        // Navigation will be handled by the parent view
        // This function serves as a placeholder for the navigation logic
    }
}
