import Foundation

enum NotificationEndpoint: APIEndpoint {
    case getNotifications
    case deleteNotification(Int)
    
    var path: String {
        switch self {
        case .getNotifications:
            return "/api/v1/notification"
        case .deleteNotification(let notificationId):
            return "/api/v1/notification/\(notificationId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNotifications:
            return .GET
        case .deleteNotification:
            return .DELETE
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
