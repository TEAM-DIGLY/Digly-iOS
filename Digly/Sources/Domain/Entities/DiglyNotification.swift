import Foundation

struct DiglyNotification: Identifiable {
    let id: Int
    let title: String
    let content: String
    let createdAt: Date
}

struct NotificationsResult {
    let notifications: [DiglyNotification]
    let pageInfo: Pagination
}
