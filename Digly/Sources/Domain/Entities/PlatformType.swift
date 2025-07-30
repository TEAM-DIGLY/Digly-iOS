import Foundation

enum PlatformType: String, Codable, CaseIterable {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case naver = "NAVER"
    
    var displayName: String {
        switch self {
        case .kakao:
            return "카카오"
        case .apple:
            return "애플"
        case .naver:
            return "네이버"
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
        }
    }
    
    // API에서 사용하는 소문자 값 (SignInRequest에서 사용)
    var apiValue: String {
        switch self {
        case .kakao:
            return "kakao"
        case .apple:
            return "apple"
        case .naver:
            return "naver"
        }
    }
}