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
            guard let refreshToken = KeychainManager.shared.getRefreshToken(),
                  !refreshToken.isEmpty else {
                await MainActor.run {
                    AuthManager.shared.logout()
                    self.isInitializing = false
                }
                return
            }
            
            let refreshSuccess = await TokenManager.shared.ensureValidToken()
            
            await MainActor.run {
                if refreshSuccess {
                    AuthManager.shared.setLoggedIn(true)
                } else {
                    AuthManager.shared.logout()
                }
                
                self.isInitializing = false
            }
        }
    }
}
