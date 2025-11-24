import Foundation

final class FcmUseCase {
    private let repository: FcmRepositoryProtocol

    init(repository: FcmRepositoryProtocol = FcmRepository()) {
        self.repository = repository
    }

    func registerToken(_ token: String) async throws {
        try await repository.registerToken(token)
    }
}
