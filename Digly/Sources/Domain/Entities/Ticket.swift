import SwiftUI
import Foundation

struct Ticket: Codable {
    let id: Int64?
    let name: String
    let performanceTime: Date
    let place: String
    let count: Int32
    let seatNumber: String?
    let price: Int32?
    let color: [String]
    let feeling: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, performanceTime, place, count, seatNumber, price, color, feeling
    }
}

struct CreateTicketRequest: Codable {
    let name: String
    let performanceTime: Date
    let place: String
    let count: Int32
    let seatNumber: String?
    let price: Int32?
    let color: [String]
    let feeling: [String]
}

struct UpdateTicketRequest: Codable {
    let name: String
    let performanceTime: Date
    let place: String
    let count: Int32
    let seatNumber: String?
    let price: Int32?
    let color: [String]
    let feeling: [String]
}

struct PageInfo: Codable {
    let pageNum: Int32
    let pageSize: Int32
    let totalElements: Int64
    let totalPages: Int64
}

struct TicketsResponse: Codable {
    let tickets: [Ticket]
    let pageInfo: PageInfo
}


struct NotesResponse: Codable {
    let notes: [Note]
    let pageInfo: PageInfo
}

public enum TicketStatus {
    case ongoing
    case upcoming
    case completed
    case pending
}
