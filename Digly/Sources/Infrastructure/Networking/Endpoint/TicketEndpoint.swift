import Foundation

enum TicketEndpoint: APIEndpoint {
    case getTickets
    case postTicket
    case getTicket(Int)
    case putTicket(Int)
    case deleteTicket(Int)
    case getTicketsForDiggingNote
    case getTicketsComplete
    
    var path: String {
        switch self {
        case .getTickets, .postTicket:
            return "/api/v1/ticket"
        case .getTicket(let ticketId), .putTicket(let ticketId), .deleteTicket(let ticketId):
            return "/api/v1/ticket/\(ticketId)"
        case .getTicketsForDiggingNote:
            return "/api/v1/ticket/digging-note"
        case .getTicketsComplete:
            return "/api/v1/ticket/complete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTickets, .getTicket, .getTicketsForDiggingNote, .getTicketsComplete:
            return .GET
        case .postTicket:
            return .POST
        case .putTicket:
            return .PUT
        case .deleteTicket:
            return .DELETE
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
