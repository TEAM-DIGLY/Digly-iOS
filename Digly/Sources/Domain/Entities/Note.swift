import Foundation

struct Note: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
    let createdAt: Date?
    let updatedAt: Date?
    
    init(
        id: Int,
        title: String,
        content: String,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
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
