import Foundation

struct Note: Codable, Identifiable {
    let id: Int64
    let title: String
    let content: String
}

struct CreateNoteRequest: Codable {
    let ticketId: Int64
    let title: String
    let content: String
}

struct UpdateNoteRequest: Codable {
    let title: String
    let content: String
}