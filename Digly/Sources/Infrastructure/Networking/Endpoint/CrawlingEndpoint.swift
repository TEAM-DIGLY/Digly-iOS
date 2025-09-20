import Foundation

enum CrawlingEndpoint: APIEndpoint {
    case getTicketsTitle
    case getTicketsPlace
    
    var path: String {
        switch self {
        case .getTicketsTitle:
            return "/api/v1/crawling/tickets/title"
        case .getTicketsPlace:
            return "/api/v1/crawling/tickets/place"
        }
    }
    
    var method: HTTPMethod { .GET }
    var tokenType: TokenType { .accessToken }
}
