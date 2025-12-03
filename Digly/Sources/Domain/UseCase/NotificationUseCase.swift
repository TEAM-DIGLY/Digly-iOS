import Foundation

final class NotificationUseCase {
    private let repository: NotificationRepositoryProtocol

    init(repository: NotificationRepositoryProtocol = NotificationRepository()) {
        self.repository = repository
    }

    func getNotifications(page: Int = 0) async throws -> NotificationsResult {
        try await repository.getNotifications(page: page)
    }

    func deleteNotification(id: Int) async throws {
        try await repository.deleteNotification(id: id)
    }
}
