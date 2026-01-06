import SwiftUI
import Foundation

struct Ticket: Identifiable {
    let id: Int
    var name: String
    let time: Date
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let emotions: [Emotion]
    var notes: [Note]?
    
    
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
}


struct PageInfo: Codable {
    let pageNum: Int32
    let pageSize: Int32
    let totalElements: Int
    let totalPages: Int
}
