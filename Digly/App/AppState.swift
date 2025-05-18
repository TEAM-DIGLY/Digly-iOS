import Foundation

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = UserDefaultsManager.shared.isLoggedIn
    @Published var userDiglyTypeIndex: Int = UserDefaultsManager.shared.diglyId // TODO: UserDefaultsManager에서 관리
    @Published private(set) var isGuestMode: Bool = false
    
    static let shared = AppState()
    
    var userDigly: Digly {
        Digly.data[userDiglyTypeIndex]
    }
    
    private init() {
        userDiglyTypeIndex = 0
    }
    
    //MARK: - 메서드
    func setUserDiglyType(_ index: Int) {
        userDiglyTypeIndex = index
        UserDefaults.standard.set(index, forKey: "userDiglyTypeIndex")
    }
    
    func changeGuestMode(_ state: Bool) {
        isGuestMode = state
    }
}
    
    
    
    
