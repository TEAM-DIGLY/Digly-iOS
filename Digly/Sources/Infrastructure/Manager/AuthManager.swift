import Foundation

public enum UserDefaultKeys {
    static let isLoggedIn = "isLoggedIn"
    static let isDarkMode = "isDarkMode"
    static let nickname = "name"
    static let userDiglyType = "userDiglyType"
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var isLoggedIn: Bool = true
    
    @Published private(set) var nickname: String = ""
    @Published private(set) var diglyType: DiglyType = .analyst
    
    private init() {
        Task {
            await initializeAuthState()
        }
    }
    
    func updateNickname(_ newNickname: String) {
        nickname = newNickname
        UserDefaults.standard.set(newNickname, forKey: UserDefaultKeys.nickname)
    }
    
    // MARK: - DiglyType Management
    
    var digly: Digly {
        return Digly.data.first { $0.diglyType == diglyType } ?? Digly.data[2]
    }
    
    func updateDiglyType(_ newDiglyType: DiglyType) {
        diglyType = newDiglyType
        UserDefaults.standard.set(newDiglyType.rawValue, forKey: UserDefaultKeys.userDiglyType)
    }
    
    // MARK: - Image Name Properties
    
    var avatarImageName: String {
        return "\(diglyType.imageName)_avatar"
    }
    
    var avatarBoxImageName: String {
        return "\(diglyType.imageName)_avatar_box"
    }
    
    var profileImageName: String {
        return "\(diglyType.imageName)_profile"
    }
    
    var baseImageName: String {
        return "\(diglyType.imageName)_base"
    }
    
    var liveBaseImageName: String {
        return "\(diglyType.imageName)_live_base"
    }
    
    var logoImageName: String {
        return "\(diglyType.imageName)_logo"
    }
    
    private func initializeAuthState() async {
        let savedLoginState = UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn)
        
        // Load saved DiglyType
        if let savedDiglyTypeString = UserDefaults.standard.string(forKey: UserDefaultKeys.userDiglyType),
           let savedDiglyType = DiglyType(rawValue: savedDiglyTypeString) {
            diglyType = savedDiglyType
        } else {
            diglyType = .communicator
        }
        
        if savedLoginState {
            if let accessToken = KeychainManager.shared.getAccessToken(),
               let refreshToken = KeychainManager.shared.getRefreshToken(),
               !accessToken.isEmpty, !refreshToken.isEmpty {
                isLoggedIn = true
                
                nickname = UserDefaults.standard.string(forKey: UserDefaultKeys.nickname) ?? ""
            } else {
                logout()
            }
        } else {
            isLoggedIn = false
            nickname = ""
        }
        
        isLoading = false
    }

    
    func login(_ accessToken: String, _ refreshToken: String, _ name: String, _ _diglyType: DiglyType) {
        isLoggedIn = true
        nickname = name
        
        diglyType = _diglyType
        
        KeychainManager.shared.saveTokens(accessToken, refreshToken)
        UserDefaults.standard.set(name, forKey: UserDefaultKeys.nickname)
        UserDefaults.standard.set(_diglyType.rawValue, forKey: UserDefaultKeys.userDiglyType)
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
    }

    func logout() {
        isLoggedIn = false
        nickname = ""
        diglyType = .communicator
        
        KeychainManager.shared.clearTokens()
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.nickname)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userDiglyType)
    }
}
