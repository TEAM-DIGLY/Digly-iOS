import Foundation

enum HomeRoute: BaseRoute {
    //    case home
    case alarmList
    case myPage
    case ticketFlow
    case inquiry
    case profileSetting
    case withdrawal
    case agreementDetail(AgreementType)

    case ticketDetail(Int)
    case editTicket(Ticket)
    case noteDetail(ticketId: Int, noteId: Int)
    
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
