import Foundation

@MainActor
class SelectNoteTicketViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var selectedTicketId: Int? = nil
    @Published var isLoading: Bool = false
    
    private let ticketUseCase: TicketUseCase
    
    var selectedTicket: Ticket? {
        tickets.first { $0.id == selectedTicketId }
    }
    
    init(
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.ticketUseCase = ticketUseCase
        
        loadTickets()
    }
    
    func selectTicket(_ ticket: Ticket) {
        if selectedTicketId == ticket.id {
            selectedTicketId = nil
        } else {
            selectedTicketId = ticket.id
        }
    }
    
    private func loadTickets() {
        Task {
            do {
                isLoading = true
                let result = try await ticketUseCase.getAllTickets(page: 0)
                tickets = result.tickets
                
                if let selectedId = selectedTicketId,
                   tickets.contains(where: { $0.id == selectedId }) == false {
                    selectedTicketId = nil
                }
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 조회"))
            }
        }
    }
}
