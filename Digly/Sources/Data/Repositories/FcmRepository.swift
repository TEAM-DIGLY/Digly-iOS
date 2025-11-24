import Foundation

final class FcmRepository: FcmRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func registerToken(_ token: String) async throws {
        let request = PostFcmRequest(token: token)
        let _: PostFcmResponse = try await networkAPI.request(
            FcmEndpoint.postToken,
            parameters: request.toDictionary()
        )
    }
}
