import Foundation

final class CrawlingRepository: CrawlingRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func searchTicketTitle(_ value: String) async throws -> [String] {
        let response: GetCrawlingTicketsTitleResponse = try await networkAPI.request(
            CrawlingEndpoint.getTicketsTitle,
            queryParameters: ["title": value]
        )
        return response.titleList
    }

    func searchTicketPlace(_ value: String) async throws -> [String] {
        let response: GetCrawlingTicketsPlaceResponse = try await networkAPI.request(
            CrawlingEndpoint.getTicketsPlace,
            queryParameters: ["key": value]
        )
        return response.placeList
    }
}
