import Foundation

struct Note: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
}

struct CreateNoteRequest: Codable {
    let ticketId: Int
    let title: String
    let content: String
}

struct UpdateNoteRequest: Codable {
    let title: String
    let content: String
}
