import Foundation

struct Note: Identifiable {
    let id: Int
    let contents: [NoteContent]
    let updatedAt: Date
}

struct NoteContent: Codable {
    let question: String
    let answer: String
}
