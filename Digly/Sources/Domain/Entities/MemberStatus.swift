import Foundation

enum MemberStatus: String, Codable, CaseIterable {
    case login = "LOGIN"
    case activate = "ACTIVATE"
    case withdraw = "WITHDRAW"
    
    var displayName: String {
        switch self {
        case .login:
            return "로그인"
        case .activate:
            return "활성화"
        case .withdraw:
            return "탈퇴"
        }
    }
    
    var isActive: Bool {
        switch self {
        case .login, .activate:
            return true
        case .withdraw:
            return false
        }
    }
}