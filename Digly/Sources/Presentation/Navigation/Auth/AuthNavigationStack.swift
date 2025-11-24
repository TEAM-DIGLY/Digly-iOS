import SwiftUI

@MainActor
final class AuthRouter: BaseRouter {
    typealias RouteType = AuthRoute
    @Published var path = NavigationPath()
}

struct AuthNavigationStack: View {
    @EnvironmentObject private var authRouter: AuthRouter
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            OnboardingView()
                .navigationDestination(for: AuthRoute.self) { route in
                    destinationView(for: route)
                        .swipeBackDisabled(route.disableSwipeBack)
                        .onAppear {
                            // print("📊 Auth Analytics: \(route.analyticsName)")
                            // print("🔒 SwipeBack disabled: \(route.disableSwipeBack)")
                        }
                }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AuthRoute) -> some View {
        switch route {
        case .createAccount(let accessToken, let refreshToken):
            CreateAccountView(accessToken: accessToken, refreshToken: refreshToken)
        case .onboarding:
            OnboardingView()
        case .onboardingConfirm(let signUpResponse, let accessToken, let refreshToken):
            OnboardingConfirmView(signUpResponse: signUpResponse, accessToken: accessToken, refreshToken: refreshToken)
        case .agreementDetail(let type):
            AgreementDetailView(agreementType: type)
        }
    }
}

#Preview {
    AuthNavigationStack()
}
