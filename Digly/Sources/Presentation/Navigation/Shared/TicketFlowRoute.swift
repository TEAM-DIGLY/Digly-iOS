import Foundation

enum TicketFlowRoute: BaseRoute {
    case addTicket
    case ticketAutoInput
    case createTicketForm
    case endCreateTicket(ticketData: CreateTicketFormData)
    
    var id: String {
        switch self {
        case .endCreateTicket(let ticketData):
            "endCreateTicket_\(ticketData.showName)_\(ticketData.place)"
        default:
            String(describing: self)
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}
