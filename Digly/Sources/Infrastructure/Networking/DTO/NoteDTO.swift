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

struct PostNoteResponse: Codable {
    let status: Int
    let message: String
    let data: NoteData

    struct NoteData: Codable {
        let id: Int
        let contents: [NoteContentDTO]

        struct NoteContentDTO: Codable {
            let question: String
            let answer: String

            func toDomain() -> NoteContent {
                NoteContent(question: question, answer: answer)
            }
        }
    }

    func toDomain() -> Note {
        Note(
            id: data.id,
            contents: data.contents.map { $0.toDomain() },
            updatedAt: Date()
        )
    }
}

// MARK: - GET /api/v1/note/{noteId}
/// - Note: `RequestDTO 불필요`
struct GetNoteResponse: Codable {
    let status: Int
    let message: String
    let data: NoteData

    struct NoteData: Codable {
        let id: Int
        let contents: [NoteContentDTO]
        let updatedAt: String

        struct NoteContentDTO: Codable {
            let question: String
            let answer: String

            func toDomain() -> NoteContent {
                NoteContent(question: question, answer: answer)
            }
        }
    }

    func toDomain() -> Note {
        Note(
            id: data.id,
            contents: data.contents.map { $0.toDomain() },
            updatedAt: data.updatedAt.toDate()
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

struct PutNoteResponse: Codable {
    let status: Int
    let message: String
    let data: NoteData

    struct NoteData: Codable {
        let id: Int
        let contents: [NoteContentDTO]

        struct NoteContentDTO: Codable {
            let question: String
            let answer: String

            func toDomain() -> NoteContent {
                NoteContent(question: question, answer: answer)
            }
        }
    }

    func toDomain() -> Note {
        Note(
            id: data.id,
            contents: data.contents.map { $0.toDomain() },
            updatedAt: Date()
        )
    }
}

// MARK: - GET /api/v1/note/ticket/{ticketId}
/// - Note: `RequestDTO 불필요` (query parameters: pageable)
struct GetNotesByTicketResponse: Codable {
    let status: Int
    let message: String
    let data: NotesData

    struct NotesData: Codable {
        let notes: [NoteDTO]
        let pageInfo: Pagination

        struct NoteDTO: Codable {
            let id: Int
            let contents: [NoteContentDTO]
            let updatedAt: String

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
                    updatedAt: updatedAt.toDate()
                )
            }
        }
    }

    func toDomain() -> NotesResult {
        NotesResult(
            notes: data.notes.map { $0.toDomain() },
            pageInfo: data.pageInfo
        )
    }
}

// MARK: - Domain Results
struct NotesResult {
    let notes: [Note]
    let pageInfo: Pagination
}
