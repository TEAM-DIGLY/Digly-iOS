import Foundation

enum AuthEndpoint: APIEndpoint {
    case postLogin(String) // socialToken
    case postSignup(String) // socialToken
    case postReissue(String) // refreshToken
    
    var path: String {
        switch self {
        case .postLogin:
            return "/api/v1/auth/login"
        case .postSignup:
            return "/api/v1/auth/signup"
        case .postReissue:
            return "/api/v1/auth/reissue"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postLogin, .postSignup, .postReissue:
            return .POST
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .postLogin(let socialToken):
            return .custom(key: "Authorization", value: socialToken)
        case .postSignup(let socialToken):
            return .custom(key: "Authorization", value: socialToken)
        case .postReissue(let refreshToken):
            return .custom(key: "Authorization", value: refreshToken)
        }
    }
}