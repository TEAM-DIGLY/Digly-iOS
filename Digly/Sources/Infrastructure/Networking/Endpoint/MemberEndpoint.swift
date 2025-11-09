import Foundation

enum MemberEndpoint: APIEndpoint {
    case getMember
    case putMember
    case patchMember
    case validateName
    
    var path: String {
        switch self {
        case .getMember, .putMember, .patchMember:
            return "/api/v1/member"
        case .validateName:
            return "/api/v1/member/name"
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
        case .validateName:
            return .GET
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .getMember, .putMember, .patchMember, .validateName:
            return .accessToken
        }
    }
}
