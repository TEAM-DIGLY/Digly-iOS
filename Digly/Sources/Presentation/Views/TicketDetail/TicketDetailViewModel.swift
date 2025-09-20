import Foundation
import Combine
import SwiftUI

class TicketDetailViewModel: ObservableObject {
    @Published var ticket: Ticket?
    @Published var isLoading: Bool = false
    
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
                isLoading = false
            } catch {
                
            }
        }
        
    }
    
    func goToDiggingNote() {
        print("디깅노트로 이동 - TicketId: ")
    }
} 
