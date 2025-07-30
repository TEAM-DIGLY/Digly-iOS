import Foundation

public enum UserDefaultKeys {
    static let isLoggedIn = "isLoggedIn"
    static let isDarkMode = "isDarkMode"
    static let nickname = "nickname"
    static let userDiglyType = "userDiglyType"
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var nickname: String = ""
    
    private init() {
        Task {
            await initializeAuthState()
        }
    }
    
    func saveNickname(_ _nickname: String) {
        nickname = _nickname
        
        UserDefaults.standard.set(_nickname, forKey: UserDefaultKeys.nickname)
    }
    
    private func initializeAuthState() async {
        let savedLoginState = UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn)
        
        if savedLoginState {
            if let accessToken = KeychainManager.shared.getAccessToken(),
               let refreshToken = KeychainManager.shared.getRefreshToken(),
               !accessToken.isEmpty, !refreshToken.isEmpty {
                isLoggedIn = true
            } else {
                logout()
            }
        } else {
            isLoggedIn = false
        }
        
        isLoading = false
    }

    
    func login(_ accessToken: String, _ refreshToken: String, _ nickname: String) {
        isLoggedIn = true
        
        KeychainManager.shared.saveTokens(accessToken, refreshToken)
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
        UserDefaults.standard.set(nickname, forKey: UserDefaultKeys.nickname)
    }

    func logout() {
        isLoggedIn = false
        
        KeychainManager.shared.clearTokens()
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.nickname)
    }
}
