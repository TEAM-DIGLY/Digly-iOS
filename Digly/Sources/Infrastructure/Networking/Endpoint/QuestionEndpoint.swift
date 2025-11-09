import Foundation

enum QuestionEndpoint: APIEndpoint {
    case postQuestion
    
    var path: String {
        switch self {
        case .postQuestion:
            return "/api/v1/question"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postQuestion:
            return .POST
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .postQuestion:
            return .accessToken
        }
    }
}