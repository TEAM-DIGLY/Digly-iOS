import Foundation

enum TicketEndpoint: APIEndpoint {
    case getTickets
    case postTicket
    case getTicket(Int64)
    case putTicket(Int64)
    
    var path: String {
        switch self {
        case .getTickets, .postTicket:
            return "/api/v1/ticket"
        case .getTicket(let ticketId), .putTicket(let ticketId):
            return "/api/v1/ticket/\(ticketId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTickets, .getTicket:
            return .GET
        case .postTicket:
            return .POST
        case .putTicket:
            return .PUT
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .getTickets, .postTicket, .getTicket, .putTicket:
            return .accessToken
        }
    }
}