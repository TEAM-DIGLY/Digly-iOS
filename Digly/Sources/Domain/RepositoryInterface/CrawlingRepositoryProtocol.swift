import Foundation

protocol CrawlingRepositoryProtocol {
    func getTicketsTitleByTitle(title: String) async throws -> APIResponse<CrawlingTicketsTitleResponse>
}
