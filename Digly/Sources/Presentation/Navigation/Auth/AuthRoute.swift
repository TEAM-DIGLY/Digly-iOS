import Foundation

enum AuthRoute: BaseRoute {
    case createAccount
    case onboarding
    
    var id: String {
        String(describing: self)
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .createAccount: true
        default: false
        }
    }
}
