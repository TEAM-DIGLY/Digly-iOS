import Foundation

// MARK: - GET /api/v1/crawling/tickets/title
/// - Note: `RequestDTO 불필요` (query parameter: title)
struct GetCrawlingTicketsTitleResponse: Codable {
    let status: Int
    let message: String
    let data: TitleListData

    struct TitleListData: Codable {
        let titleList: [String]
    }
}

// MARK: - GET /api/v1/crawling/tickets/place
/// - Note: `RequestDTO 불필요` (query parameter: key)
struct GetCrawlingTicketsPlaceResponse: Codable {
    let status: Int
    let message: String
    let data: PlaceListData

    struct PlaceListData: Codable {
        let placeList: [String]
    }
}
