import Foundation
import SwiftUI

struct TicketsResponse: Codable {
    let tickets: [TicketDTO]
    let pageInfo: PageInfo
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

struct NotesResponse: Codable {
    let notes: [Note]
    let pageInfo: PageInfo
}

struct CreateTicketRequest: Codable {
    let name: String
    let time: Date
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
}

struct UpdateTicketRequest: Codable {
    let name: String
    let time: Date
    let place: String
    let count: Int32
    let seatNumber: String?
    let price: Int32?
    let color: [String]
    let feeling: [String]
}
