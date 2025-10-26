import Foundation

// MARK: - Note Response DTOs


struct GetNotesResponseDTO: Codable {
    let notes: [NoteDTO]
    let pageInfo: PageInfo

    func toDomain() -> NotesResponse {
        NotesResponse(
            notes: notes.map { $0.toDomain() },
            pageInfo: pageInfo
        )
    }
}

// MARK: - Note Request DTOs

struct CreateNoteRequestDTO: Codable {
    let ticketId: Int
    let contents: [String]
}

struct CreateNoteResponseDTO: Codable {
    let ticketId: Int
    let contents: [String]
}
struct UpdateNoteRequestDTO: Codable {
    let contents: [String]
}


struct NoteDTO: Codable {
    let id: Int
    let contents: [NoteContentDTO]
    let updateAt: String

    struct NoteContentDTO: Codable {
        let question: String
        let answer: String
        
        func toDomain() -> NoteContent {
            NoteContent(question: question, answer: answer)
        }
    }
    
    func toDomain() -> Note {
        Note(
            id: id,
            contents: contents.map{$0.toDomain()},
            updateAt: updateAt.toDate()
        )
    }
}
