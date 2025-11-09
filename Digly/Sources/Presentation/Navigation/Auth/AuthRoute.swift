import Foundation

enum AuthRoute: BaseRoute {
    case createAccount(accessToken: String, refreshToken: String)
    case onboarding
    case onboardingConfirm(signUpResponse: SignUpResult, accessToken: String, refreshToken: String, diglyType: DiglyType)
    case agreementDetail(type: AgreementType)

    var id: String {
        switch self {
        case .createAccount:
            return "createAccount"
        case .onboarding:
            return "onboarding"
        case .onboardingConfirm:
            return "onboardingConfirm"
        case .agreementDetail:
            return "agreementDetail"
        }
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .createAccount: true
        case .onboardingConfirm: true
        default: false
        }
    }
}
