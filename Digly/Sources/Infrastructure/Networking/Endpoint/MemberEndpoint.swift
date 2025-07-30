import Foundation

enum MemberEndpoint: APIEndpoint {
    case getMember
    case putMember
    case patchMember
    
    var path: String {
        switch self {
        case .getMember, .putMember, .patchMember:
            return "/api/v1/member"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMember:
            return .GET
        case .putMember:
            return .PUT
        case .patchMember:
            return .PATCH
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .getMember, .putMember, .patchMember:
            return .accessToken
        }
    }
}