import Foundation

final class CrawlingRepository: CrawlingRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func searchTicketTitle(_ value: String) async throws -> APIResponse<CrawlingTicketsTitleResponse> {
        return try await networkAPI.request(CrawlingEndpoint.getTicketsTitle, queryParameters: ["title": value])
    }
    
    func searchTicketPlace(_ value: String) async throws -> APIResponse<CrawlingTicketsPlaceResponse> {
        return try await networkAPI.request(CrawlingEndpoint.getTicketsPlace, queryParameters: ["key": value])
    }
}
