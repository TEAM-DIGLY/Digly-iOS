import Foundation

enum TicketBookRoute: BaseRoute {
    case ticketBook
    case ticketDetail(Int)
    case ticketFlow
    
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

