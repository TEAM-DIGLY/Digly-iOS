import SwiftUI
import Foundation

struct Ticket: Identifiable {
    let id: Int
    let name: String
    let time: Date
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let emotions: [Emotion]
    
    let notes: [Note]?
    
    
    init(id: Int, name: String, time: Date, place: String, count: Int, seatNumber: String?, price: Int?, emotions: [Emotion], notes: [Note]? = nil) {
        self.id = id
        self.name = name
        self.time = time
        self.place = place
        self.count = count
        self.seatNumber = seatNumber
        self.price = price
        self.emotions = emotions
        self.notes = notes
    }
    
    static let dummy: Ticket = Ticket(
        id: 1,
        name: "프랑켄슈타인",
        time: Date(),
        place: "블루스퀘어 신한카드홀",
        count: 24,
        seatNumber: "@4",
        price: 20000,
        emotions: []
    )
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
