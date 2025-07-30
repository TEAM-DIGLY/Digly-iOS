import Foundation
import Combine

final class CrawlingUseCase {
    private let crawlingRepository: CrawlingRepositoryProtocol
    
    init(crawlingRepository: CrawlingRepositoryProtocol) {
        self.crawlingRepository = crawlingRepository
    }
    
    func searchTicketTitles(query: String) async throws -> [String] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        return try await crawlingRepository.getTicketsTitleByTitle(title: query).titleList
    }
//    
//    func getRecommendedTitles(based currentTickets: [Ticket]) -> AnyPublisher<[String], APIError> {
//        // 현재 티켓들을 기반으로 추천 제목을 가져오는 로직
//        // 가장 최근 티켓의 장르나 키워드를 기반으로 검색
//        guard let latestTicket = currentTickets.first else {
//            return Just([])
//                .setFailureType(to: APIError.self)
//                .eraseToAnyPublisher()
//        }
//        
//        // 티켓 이름에서 키워드를 추출하여 관련 공연 검색
//        let keywords = extractKeywords(from: latestTicket.name)
//        
//        if let firstKeyword = keywords.first {
//            return searchTicketTitles(query: firstKeyword)
//        } else {
//            return Just([])
//                .setFailureType(to: APIError.self)
//                .eraseToAnyPublisher()
//        }
//    }
    
    private func extractKeywords(from title: String) -> [String] {
        // 간단한 키워드 추출 로직 (향후 NLP 라이브러리로 개선 가능)
        let commonWords = ["뮤지컬", "연극", "콘서트", "오페라", "발레", "클래식"]
        return commonWords.filter { title.contains($0) }
    }
}
