import Foundation

enum TicketFlowRoute: BaseRoute {
    case addTicket
    case ticketAutoInput
    case createTicketForm
    case ticketAutoConfirm(ticketForm: CreateTicketFormData)
    case endCreateTicket(ticket: Ticket)
    
    var id: String {
        switch self {
        case .endCreateTicket(let ticket):
            "endCreateTicket_\(ticket.name)_\(ticket.place)"
        default:
            String(describing: self)
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}
