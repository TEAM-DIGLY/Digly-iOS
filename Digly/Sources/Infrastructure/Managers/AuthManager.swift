import Foundation
import Combine

public enum UserDefaultKeys {
    static let isLoggedIn = "isLoggedIn"
    static let isDarkMode = "isDarkMode"
    static let userDiglyType = "userDiglyType"
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published private(set) var isLoggedIn: Bool = true

    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn)
    }

    func login() {
        isLoggedIn = true
        
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
    }

    func logout() {
        isLoggedIn = false
        
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLoggedIn)
        
        KeychainManager.shared.clearToken()
    }
}
