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
    
    @Published private(set) var isLoggedIn: Bool = false
    
    @Published private(set) var nickname: String = ""
    @Published private(set) var diglyType: DiglyType = .analyst
    
    private init() {
        loadUserData()
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
    
    var paddingBottom: CGFloat {
        switch diglyType {
        case .analyst:
            -28
        case .collector:
            -28
        case .communicator:
            0       
        }
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
    
    private func loadUserData() {
        // Load saved DiglyType
        if let savedDiglyTypeString = UserDefaults.standard.string(forKey: UserDefaultKeys.userDiglyType),
           let savedDiglyType = DiglyType(rawValue: savedDiglyTypeString) {
            diglyType = savedDiglyType
        } else {
            diglyType = .communicator
        }
        
        // Load nickname
        nickname = UserDefaults.standard.string(forKey: UserDefaultKeys.nickname) ?? ""
        
        // isLoggedIn will be set by DiglyViewModel after token validation
        isLoggedIn = false
    }
    
    func setLoggedIn(_ loggedIn: Bool) {
        isLoggedIn = loggedIn
        if loggedIn {
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
        } else {
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLoggedIn)
        }
    }

    
    func login(_ accessToken: String, _ refreshToken: String, _ name: String, _ _diglyType: DiglyType) {
        nickname = name
        diglyType = _diglyType
        
        KeychainManager.shared.saveTokens(accessToken, refreshToken)
        UserDefaults.standard.set(name, forKey: UserDefaultKeys.nickname)
        UserDefaults.standard.set(_diglyType.rawValue, forKey: UserDefaultKeys.userDiglyType)
        
        setLoggedIn(true)
    }

    func logout() {
        nickname = ""
        diglyType = .communicator
        
        KeychainManager.shared.clearTokens()
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.nickname)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userDiglyType)
        
        setLoggedIn(false)
        
        // Clear tokens in TokenManager as well
        Task {
            await TokenManager.shared.clearTokens()
        }
    }
}
