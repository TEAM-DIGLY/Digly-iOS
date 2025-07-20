import Foundation

enum TicketBookRoute: BaseRoute {
    case ticketBook
    case ticketDetail(String)
    
    var id: String {
        switch self {
        case .ticketBook:
            return "ticketBook"
        case .ticketDetail(let ticketId):
            return "ticketDetail_\(ticketId)"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

