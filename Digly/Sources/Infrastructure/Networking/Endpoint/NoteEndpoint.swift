import Foundation

enum NoteEndpoint: APIEndpoint {
    case postNote
    case getNote(Int)
    case putNote(Int)
    case getNotesByTicket(Int)
    case deleteNote(Int)
    case getNotesWithoutTicket
    
    var path: String {
        switch self {
        case .postNote:
            return "/api/v1/note"
        case .getNote(let noteId), .putNote(let noteId):
            return "/api/v1/note/\(noteId)"
        case .getNotesByTicket(let ticketId):
            return "/api/v1/note/ticket/\(ticketId)"
        case .deleteNote(let noteId):
            return "/api/v1/note/\(noteId)"
        case .getNotesWithoutTicket:
            return "/api/v1/note/ticket-none"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNote, .getNotesByTicket, .getNotesWithoutTicket:
            return .GET
        case .postNote:
            return .POST
        case .putNote:
            return .PUT
        case .deleteNote:
            return .DELETE
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .postNote, .getNote, .putNote, .getNotesByTicket, .deleteNote, .getNotesWithoutTicket:
            return .accessToken
        }
    }
}
