import Foundation

enum PlatformType: String, Codable, CaseIterable {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case naver = "NAVER"
    case withdraw = "WITHDRAW"
    
    var displayName: String {
        switch self {
        case .kakao:
            return "카카오"
        case .apple:
            return "애플"
        case .naver:
            return "네이버"
        case .withdraw:
            return "탈퇴"
        }
    }
    
    var iconName: String {
        switch self {
        case .kakao:
            return "kakao_icon"
        case .apple:
            return "apple_icon"
        case .naver:
            return "naver_icon"
        case .withdraw:
            return "withdraw_icon"
        }
    }
}
