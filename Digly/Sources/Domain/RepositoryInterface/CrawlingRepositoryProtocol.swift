import Foundation

protocol CrawlingRepositoryProtocol {
    func searchTicketTitle(_ value: String) async throws -> APIResponse<CrawlingTicketsTitleResponse>
    func searchTicketPlace(_ value: String) async throws -> APIResponse<CrawlingTicketsPlaceResponse>
}
