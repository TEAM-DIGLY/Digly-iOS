import Foundation

enum HomeRoute: BaseRoute {
    //    case home
    case alarmList
    case myPage
    case ticketFlow
    case inquiry
    case profileSetting
    case agreementDetail(AgreementType)
    
    var id: String {
        String(describing: self)
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .inquiry:
            true
        default:
            false
        }
    }
}
