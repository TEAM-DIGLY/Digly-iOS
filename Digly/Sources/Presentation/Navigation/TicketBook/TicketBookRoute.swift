import Foundation

enum TicketBookRoute: BaseRoute {
    case ticketBook
    case ticketFlow
    case ticketDetail(Int)
    case editTicket(Ticket)
    case noteDetail(ticketId: Int, noteId: Int)
    
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

