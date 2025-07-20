import Foundation

enum HomeRoute: BaseRoute {
//    case home
    case alarmList
    case myPage
    
    var id: String {
        String(describing: self)
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

