import Foundation

final class CrawlingRepository: CrawlingRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getTicketsTitleByTitle(title: String) async throws -> APIResponse<CrawlingTicketsTitleResponse> {
        return try await networkAPI.request(
            CrawlingEndpoint.getTicketsTitle,
            queryParameters: ["title": title]
        )
    }
}
