import Foundation
import Combine
import SwiftUI

class TicketDetailViewModel: ObservableObject {
    @Published var ticket: Ticket?
    @Published var isLoading: Bool = false
    @Published var hasEmotions: Bool = false

    let ticketUseCase: TicketUseCase
    
    init(
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.ticketUseCase = ticketUseCase
    }
    
    func getTicketDetail(id: Int) {
        Task {
            do {
                isLoading = true
                ticket = try await ticketUseCase.getTicketDetail(ticketId: id)

                // Check if ticket has emotions
                if let ticket = ticket {
                    hasEmotions = !ticket.feeling.isEmpty
                }

                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 상세 조회"))
            }
        }
    }
    
    func goToDiggingNote() {
    }
} 
