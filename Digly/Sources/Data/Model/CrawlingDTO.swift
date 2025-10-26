import Foundation

// MARK: - GET /api/v1/crawling/tickets/title
/// - Note: `RequestDTO 불필요` (query parameter: title)
struct GetCrawlingTicketsTitleResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let titleList: [String]
}

// MARK: - GET /api/v1/crawling/tickets/place
/// - Note: `RequestDTO 불필요` (query parameter: key)
struct GetCrawlingTicketsPlaceResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let placeList: [String]
}
