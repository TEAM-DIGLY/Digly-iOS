import Foundation
import Combine

@MainActor
final class DiglyManager: ObservableObject {
    static let shared = DiglyManager()
    
    @Published private(set) var diglyType: DiglyType = .analyst // 기본값은 communicator
    
    var digly: Digly {
        return Digly.data.first { $0.diglyType == diglyType } ?? Digly.data[2]
    }
    
    private init() {
        if let savedDiglyTypeString = UserDefaults.standard.string(forKey: UserDefaultKeys.userDiglyType),
           let savedDiglyType = DiglyType(rawValue: savedDiglyTypeString) {
            self.diglyType = savedDiglyType
        } else {
            self.diglyType = .communicator
        }
    }
    
    /// 디글리 유형 변경
    /// - Parameter diglyType: 새로운 디글리 유형
    func changeDiglyType(to newDiglyType: DiglyType) {
        diglyType = newDiglyType
        
        UserDefaults.standard.set(newDiglyType.rawValue, forKey: UserDefaultKeys.userDiglyType)
    }
    
    /// 디글리 유형 업데이트 (ProfileSettingView용)
    /// - Parameter diglyType: 새로운 디글리 유형
    func updateDiglyType(_ newDiglyType: DiglyType) {
        changeDiglyType(to: newDiglyType)
    }
    
    /// 이미지 이름들 (연산 속성)
    var avatarImageName: String {
        return "\(diglyType.rawValue)_avatar"
    }
    
    var avatarBoxImageName: String {
        return "\(diglyType.rawValue)_avatar_box"
    }
    
    var profileImageName: String {
        return "\(diglyType.rawValue)_profile"
    }
    
    var baseImageName: String {
        return "\(diglyType.rawValue)_base"
    }
    
    var liveBaseImageName: String {
        return "\(diglyType.rawValue)_live_base"
    }
    
    var logoImageName: String {
        return "\(diglyType.rawValue)_logo"
    }
    
    /// 디글리 초기화 (로그아웃 시 사용)
    func resetDigly() {
        diglyType = .communicator
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userDiglyType)
    }
} 
