import Foundation
import Combine

final class CrawlingUseCase {
    private let crawlingRepository: CrawlingRepositoryProtocol
    
    init(crawlingRepository: CrawlingRepositoryProtocol) {
        self.crawlingRepository = crawlingRepository
    }
    
    func searchTicketTitles(query: String) async throws -> [String] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }
        return try await crawlingRepository.searchTicketTitle(query)
    }
    
    func searchTicketPlaces(query: String) async throws -> [String] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return [] }
        return try await crawlingRepository.searchTicketPlace(query)
    }
}
