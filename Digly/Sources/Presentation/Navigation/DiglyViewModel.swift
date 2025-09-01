import Foundation

@MainActor
final class DiglyViewModel: ObservableObject {
    @Published private(set) var isInitializing = true
    @Published var selectedTab = 0
    
    func initialize() async {
        await handleAuthState()
        isInitializing = false
    }
    
    private func handleAuthState() async {
        let refreshSuccess = await TokenManager.shared.ensureValidToken()
        if refreshSuccess {
            AuthManager.shared.setLoggedIn(true)
        } else {
            AuthManager.shared.logout()
        }
    }
}
