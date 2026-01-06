import Foundation

struct Alarm: Identifiable {
    let id: Int
    let title: String
    let content: String
    let createdAt: Date
}

struct NotificationsResult {
    let notifications: [Alarm]
    let pageInfo: Pagination
}
