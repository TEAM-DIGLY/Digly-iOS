import Foundation

final class NotificationRepository: NotificationRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func getNotifications(page: Int, size: Int) async throws -> NotificationsResult {
        let query: [String: String] = [
            "page": "\(page)",
            "size": "\(size)"
        ]

        let response: GetNotificationsResponse = try await networkAPI.request(
            NotificationEndpoint.getNotifications,
            queryParameters: query
        )
        return response.toDomain()
    }

    func deleteNotification(id: Int) async throws {
        let _: DeleteNotificationResponse = try await networkAPI.request(
            NotificationEndpoint.deleteNotification(id)
        )
    }
}
