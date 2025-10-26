import Foundation
import SwiftUI

// MARK: - GET /api/v1/ticket
/// - Note: `RequestDTO 불필요` (query parameters: key, startAt, endAt, pageable)
struct GetTicketsResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let tickets: [TicketDTO]
    let pageInfo: Pagination

    struct TicketDTO: Codable {
        let id: Int
        let name: String
        let performanceTime: String
        let place: String
        let count: Int
        let seatNumber: String?
        let price: Int?
        let color: [String]
        let feeling: [String]
        let isDeleted: Bool

        func toDomain() -> Ticket {
            Ticket(
                id: id,
                name: name,
                time: performanceTime.toDate(),
                place: place,
                count: count,
                seatNumber: seatNumber,
                price: price,
                color: EmotionColor.fromRawValues(color),
                feeling: feeling.map { Feeling(rawValue: $0) ?? .excited }
            )
        }
    }

    func toDomain() -> TicketsResult {
        TicketsResult(
            tickets: tickets.map { $0.toDomain() },
            pageInfo: pageInfo
        )
    }
}

// MARK: - POST /api/v1/ticket
struct PostTicketRequest: Codable {
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
}

struct PostTicketResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
    let isDeleted: Bool

    func toDomain() -> Ticket {
        Ticket(
            id: id,
            name: name,
            time: performanceTime.toDate(),
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: EmotionColor.fromRawValues(color),
            feeling: feeling.map { Feeling(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - GET /api/v1/ticket/{ticketId}
/// - Note: `RequestDTO 불필요`
struct GetTicketResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
    let isDeleted: Bool

    func toDomain() -> Ticket {
        Ticket(
            id: id,
            name: name,
            time: performanceTime.toDate(),
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: EmotionColor.fromRawValues(color),
            feeling: feeling.map { Feeling(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - PUT /api/v1/ticket/{ticketId}
struct PutTicketRequest: Codable {
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
}

struct PutTicketResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
    let isDeleted: Bool

    func toDomain() -> Ticket {
        Ticket(
            id: id,
            name: name,
            time: performanceTime.toDate(),
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: EmotionColor.fromRawValues(color),
            feeling: feeling.map { Feeling(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - DELETE /api/v1/ticket/{ticketId}
/// - Note: `RequestDTO 불필요` (query parameter: isOptional)
struct DeleteTicketResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let data: EmptyResult?
}

// MARK: - Domain Results
struct TicketsResult {
    let tickets: [Ticket]
    let pageInfo: Pagination
}
