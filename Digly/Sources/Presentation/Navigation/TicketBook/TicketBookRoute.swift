import Foundation

enum TicketBookRoute: BaseRoute {
    case ticketBook
    case ticketDetail(String)
    case addTicket
    case createTicketForm
    
    var id: String {
        switch self {
        case .ticketDetail(let ticketId):
            "ticketDetail_\(ticketId)"
        default:
            String(describing: self)
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

