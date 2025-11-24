import Foundation

enum OnboardingEndpoint: APIEndpoint {
    case get(onboardingType: String)
    case updateVisible(onboardingType: String)
    
    var path: String {
        return "/api/v1/onboarding"
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .GET
        case .updateVisible:
            return .PATCH
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
