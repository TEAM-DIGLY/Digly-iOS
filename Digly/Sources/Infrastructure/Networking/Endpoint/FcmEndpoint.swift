import Foundation

enum FcmEndpoint: APIEndpoint {
    case postToken
    
    var path: String {
        switch self {
        case .postToken:
            return "/api/v1/fcm"
        }
    }
    
    var method: HTTPMethod { .POST }
    var tokenType: TokenType { .accessToken }
}
