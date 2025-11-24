import Foundation

final class NotificationUseCase {
    private let repository: NotificationRepositoryProtocol

    init(repository: NotificationRepositoryProtocol = NotificationRepository()) {
        self.repository = repository
    }

    func getNotifications(page: Int = 0, size: Int = 20) async throws -> NotificationsResult {
        try await repository.getNotifications(page: page, size: size)
    }

    func deleteNotification(id: Int) async throws {
        try await repository.deleteNotification(id: id)
    }
}
