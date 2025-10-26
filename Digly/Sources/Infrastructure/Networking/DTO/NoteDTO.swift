import Foundation

// MARK: - POST /api/v1/note
struct PostNoteRequest: Codable {
    let ticketId: Int
    let contents: [NoteContentDTO]

    struct NoteContentDTO: Codable {
        let question: String
        let answer: String
    }
}

struct PostNoteResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let contents: [NoteContentDTO]

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
            contents: contents.map { $0.toDomain() },
            updateAt: Date()
        )
    }
}

// MARK: - GET /api/v1/note/{noteId}
/// - Note: `RequestDTO 불필요`
struct GetNoteResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
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
            contents: contents.map { $0.toDomain() },
            updateAt: updateAt.toDate()
        )
    }
}

// MARK: - PUT /api/v1/note/{noteId}
struct PutNoteRequest: Codable {
    let contents: [NoteContentDTO]

    struct NoteContentDTO: Codable {
        let question: String
        let answer: String
    }
}

struct PutNoteResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let contents: [NoteContentDTO]

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
            contents: contents.map { $0.toDomain() },
            updateAt: Date()
        )
    }
}

// MARK: - GET /api/v1/note/ticket/{ticketId}
/// - Note: `RequestDTO 불필요` (query parameters: pageable)
struct GetNotesByTicketResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let notes: [NoteDTO]
    let pageInfo: Pagination

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
                contents: contents.map { $0.toDomain() },
                updateAt: updateAt.toDate()
            )
        }
    }

    func toDomain() -> NotesResult {
        NotesResult(
            notes: notes.map { $0.toDomain() },
            pageInfo: pageInfo
        )
    }
}

// MARK: - Domain Results
struct NotesResult {
    let notes: [Note]
    let pageInfo: Pagination
}
