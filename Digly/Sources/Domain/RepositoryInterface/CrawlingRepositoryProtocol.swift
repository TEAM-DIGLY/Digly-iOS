import Foundation

protocol CrawlingRepositoryProtocol {
    func searchTicketTitle(_ value: String) async throws -> [String]
    func searchTicketPlace(_ value: String) async throws -> [String]
}
