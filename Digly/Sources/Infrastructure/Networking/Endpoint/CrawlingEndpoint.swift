import Foundation

enum CrawlingEndpoint: APIEndpoint {
    case getTicketsTitle
    
    var path: String {
        switch self {
        case .getTicketsTitle:
            return "/api/v1/crawling/tickets/title"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTicketsTitle:
            return .GET
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .getTicketsTitle:
            return .none
        }
    }
}