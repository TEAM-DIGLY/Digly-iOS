import Foundation

// MARK: - GET /api/v1/notification
struct GetNotificationsResponse: Codable {
    let status: Int
    let message: String
    let data: NotificationsData

    struct NotificationsData: Codable {
        let data: [NotificationDTO]
        let pageInfo: Pagination
    }

    struct NotificationDTO: Codable {
        let id: Int
        let title: String
        let content: String
        let createdAt: String

        func toDomain() -> DiglyNotification {
            DiglyNotification(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt.toDate()
            )
        }
    }

    func toDomain() -> NotificationsResult {
        NotificationsResult(
            notifications: data.data.map { $0.toDomain() },
            pageInfo: data.pageInfo
        )
    }
}

// MARK: - DELETE /api/v1/notification/{notificationId}
struct DeleteNotificationResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}
