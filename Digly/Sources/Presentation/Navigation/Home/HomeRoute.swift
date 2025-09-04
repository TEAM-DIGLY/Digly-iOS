import Foundation

enum HomeRoute: BaseRoute {
//    case home
    case alarmList
    case myPage
    case addTicket
    case ticketAutoInput
    case createTicketForm
    
    var id: String {
        String(describing: self)
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

