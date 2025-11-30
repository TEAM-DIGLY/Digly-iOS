import Foundation

enum NotificationEvent {
    case didTapTicketBook

    var name: Notification.Name {
        switch self {
        case .didTapTicketBook:
            Notification.Name("didTapTicketBook")
        }
    }

    var userInfo: String {
        switch self {
        case .didTapTicketBook:
            "targetTab"
        }
    }
}
