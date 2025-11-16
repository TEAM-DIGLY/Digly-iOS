import Foundation

enum HomeRoute: BaseRoute {
//    case home
    case alarmList
    case myPage
    case ticketFlow
    case agreementDetail(AgreementType)
    
    var id: String {
        String(describing: self)
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

