import Foundation
import SwiftUI

// MARK: - GET /api/v1/ticket
/// - Note: `RequestDTO 불필요` (query parameters: key, startAt, endAt, pageable)
struct GetTicketsResponse: Codable {
    let status: Int
    let message: String
    let data: TicketsData

    struct TicketsData: Codable {
        let tickets: [TicketDTO]
        let pageInfo: Pagination
    }

    struct TicketDTO: Codable {
        let id: Int
        let name: String
        let performanceTime: String
        let place: String
        let count: Int
        let seatNumber: String?
        let price: Int?
        let color: [String]
        let feeling: [String]

        func toDomain() -> Ticket {
            Ticket(
                id: id,
                name: name,
                time: performanceTime.toDate(),
                place: place,
                count: count,
                seatNumber: seatNumber,
                price: price,
                emotions: feeling.map { Emotion(rawValue: $0) ?? .excited }
            )
        }
    }

    func toDomain() -> TicketsResult {
        TicketsResult(
            tickets: data.tickets.map { $0.toDomain() },
            pageInfo: data.pageInfo
        )
    }
}

// MARK: - POST /api/v1/ticket
struct PostTicketRequest: Codable {
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
}

struct PostTicketResponse: Codable {
    let status: Int
    let message: String
    let data: TicketData

    struct TicketData: Codable {
        let id: Int
        let name: String
        let performanceTime: String
        let place: String
        let count: Int
        let seatNumber: String?
        let price: Int?
        let color: [String]
        let feeling: [String]
    }

    func toDomain() -> Ticket {
        Ticket(
            id: data.id,
            name: data.name,
            time: data.performanceTime.toDate(),
            place: data.place,
            count: data.count,
            seatNumber: data.seatNumber,
            price: data.price,
            emotions: data.feeling.map { Emotion(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - GET /api/v1/ticket/{ticketId}
/// - Note: `RequestDTO 불필요`
struct GetTicketResponse: Codable {
    let status: Int
    let message: String
    let data: TicketData

    struct TicketData: Codable {
        let id: Int
        let name: String
        let performanceTime: String
        let place: String
        let count: Int
        let seatNumber: String?
        let price: Int?
        let color: [String]
        let feeling: [String]
        let notes: [TicketNoteDTO]?

        struct TicketNoteDTO: Codable {
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

    func toDomain() -> Ticket {
        Ticket(
            id: data.id,
            name: data.name,
            time: data.performanceTime.toDate(),
            place: data.place,
            count: data.count,
            seatNumber: data.seatNumber,
            price: data.price,
            emotions: data.feeling.map { Emotion(rawValue: $0) ?? .excited },
            notes: data.notes?.map { $0.toDomain() }
        )
    }
}

// MARK: - PUT /api/v1/ticket/{ticketId}
struct PutTicketRequest: Codable {
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let color: [String]
    let feeling: [String]
}

struct PutTicketResponse: Codable {
    let status: Int
    let message: String
    let data: TicketData

    struct TicketData: Codable {
        let id: Int
        let name: String
        let performanceTime: String
        let place: String
        let count: Int
        let seatNumber: String?
        let price: Int?
        let color: [String]
        let feeling: [String]
    }

    func toDomain() -> Ticket {
        Ticket(
            id: data.id,
            name: data.name,
            time: data.performanceTime.toDate(),
            place: data.place,
            count: data.count,
            seatNumber: data.seatNumber,
            price: data.price,
            emotions: data.feeling.map { Emotion(rawValue: $0) ?? .excited }
        )
    }
}

// MARK: - DELETE /api/v1/ticket/{ticketId}
/// - Note: `RequestDTO 불필요` (query parameter: isOptional)
struct DeleteTicketResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}

// MARK: - GET /api/v1/ticket/digging-note
struct GetTicketsForDiggingNoteResponse: Codable {
    let status: Int
    let message: String
    let data: TicketsPageData

    struct TicketsPageData: Codable {
        let tickets: [TicketElement]
        let pageInfo: Pagination

        struct TicketElement: Codable {
            let id: Int
            let name: String
            let lastModifiedAt: String
            let noteCount: Int

            func toDomain() -> TicketDiggingNote {
                TicketDiggingNote(
                    id: id,
                    name: name,
                    lastModifiedAt: lastModifiedAt.toDate(),
                    noteCount: noteCount
                )
            }
        }
    }

    func toDomain() -> TicketDiggingNotesResult {
        TicketDiggingNotesResult(
            tickets: data.tickets.map { $0.toDomain() },
            pageInfo: data.pageInfo
        )
    }
}

// MARK: - GET /api/v1/ticket/complete
struct GetTicketsCompleteResponse: Codable {
    let status: Int
    let message: String
    let data: TicketsCompleteData

    struct TicketsCompleteData: Codable {
        let tickets: [TicketCompleteDTO]

        struct TicketCompleteDTO: Codable {
            let id: Int
            let name: String
            let performanceTime: String
            let place: String

            func toDomain() -> TicketComplete {
                TicketComplete(
                    id: id,
                    name: name,
                    performanceTime: performanceTime.toDate(),
                    place: place
                )
            }
        }
    }

    func toDomain() -> [TicketComplete] {
        data.tickets.map { $0.toDomain() }
    }
}

// MARK: - Domain Results
struct TicketsResult {
    let tickets: [Ticket]
    let pageInfo: Pagination
}

struct TicketDiggingNotesResult {
    let tickets: [TicketDiggingNote]
    let pageInfo: Pagination
}

struct TicketDiggingNote {
    let id: Int
    let name: String
    let lastModifiedAt: Date
    let noteCount: Int
}

struct TicketComplete {
    let id: Int
    let name: String
    let performanceTime: Date
    let place: String
}
