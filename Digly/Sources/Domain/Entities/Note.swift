import Foundation

struct Note: Identifiable {
    let id: Int
    let contents: [NoteContent]
    let updateAt: Date
}

struct NoteContent {
    let question: String
    let answer: String
}

struct CreateNoteRequest {
    let ticketId: Int
    let contents: [String]
}

struct UpdateNoteRequest {
    let contents: [String]
}
