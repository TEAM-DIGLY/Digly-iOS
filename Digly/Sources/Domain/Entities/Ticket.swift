import SwiftUI
import Foundation

struct Ticket: Identifiable, Codable {
    let id: Int
    let name: String
    let time: Date
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [EmotionColor]
    let feeling: [Feeling]
}


struct PageInfo: Codable {
    let pageNum: Int32
    let pageSize: Int32
    let totalElements: Int
    let totalPages: Int
}

public enum TicketStatus {
    case ongoing
    case upcoming
    case completed
    case pending
}
