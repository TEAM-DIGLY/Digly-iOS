import Foundation

protocol NotificationRepositoryProtocol {
    func getNotifications(page: Int, size: Int) async throws -> NotificationsResult
    func deleteNotification(id: Int) async throws
}
