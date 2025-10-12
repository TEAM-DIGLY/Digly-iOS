import Foundation

@MainActor
final class DiglyViewModel: ObservableObject {
    @Published private(set) var isInitializing = true
    @Published var selectedTab = 0
    
    init(){
        initialize()
    }
    
    private func initialize() {
        Task {
            let refreshSuccess = await TokenManager.shared.ensureValidToken()
            
            if refreshSuccess {
                AuthManager.shared.setLoggedIn(true)
            } else {
                AuthManager.shared.logout()
            }
            
            isInitializing = false
        }
    }
}
