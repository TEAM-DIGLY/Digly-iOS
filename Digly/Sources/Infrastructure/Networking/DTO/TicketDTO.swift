import Foundation
import SwiftUI

// MARK: - GET /api/v1/ticket
/// - Note: `RequestDTO 불필요` (query parameters: key, startAt, endAt, pageable)
struct GetTicketsResponse: Codable {
    let status: Int
    let message: String
    let data: TicketsData

    struct TicketsData: Codable {
        let tickets: [TicketDTO]
        let pageInfo: Pagination
    }

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
                emotions: feeling.map { Emotion(rawValue: $0) ?? .excited }
            )
        }
    }

    func toDomain() -> TicketsResult {
        TicketsResult(
            tickets: data.tickets.map { $0.toDomain() },
            pageInfo: data.pageInfo
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

struct PostTicketResponse: Codable {
    let status: Int
    let message: String
    let data: TicketData

    struct TicketData: Codable {
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
    }

    func toDomain() -> Ticket {
        Ticket(
            id: data.id,
            name: data.name,
            time: data.performanceTime.toDate(),
            place: data.place,
            count: data.count,
            seatNumber: data.seatNumber,
            price: data.price,
            emotions: data.feeling.map { Emotion(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - GET /api/v1/ticket/{ticketId}
/// - Note: `RequestDTO 불필요`
struct GetTicketResponse: Codable {
    let status: Int
    let message: String
    let data: TicketData

    struct TicketData: Codable {
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
    }

    func toDomain() -> Ticket {
        Ticket(
            id: data.id,
            name: data.name,
            time: data.performanceTime.toDate(),
            place: data.place,
            count: data.count,
            seatNumber: data.seatNumber,
            price: data.price,
            emotions: data.feeling.map { Emotion(rawValue: $0) ?? .excited }
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

struct PutTicketResponse: Codable {
    let status: Int
    let message: String
    let data: TicketData

    struct TicketData: Codable {
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
    }

    func toDomain() -> Ticket {
        Ticket(
            id: data.id,
            name: data.name,
            time: data.performanceTime.toDate(),
            place: data.place,
            count: data.count,
            seatNumber: data.seatNumber,
            price: data.price,
            emotions: data.feeling.map { Emotion(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - DELETE /api/v1/ticket/{ticketId}
/// - Note: `RequestDTO 불필요` (query parameter: isOptional)
struct DeleteTicketResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}

// MARK: - Domain Results
struct TicketsResult {
    let tickets: [Ticket]
    let pageInfo: Pagination
}
