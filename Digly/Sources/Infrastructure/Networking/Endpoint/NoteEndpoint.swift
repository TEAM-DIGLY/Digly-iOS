import Foundation

enum NoteEndpoint: APIEndpoint {
    case postNote
    case getNote(Int)
    case putNote(Int)
    case getNotesByTicket(Int)
    
    var path: String {
        switch self {
        case .postNote:
            return "/api/v1/note"
        case .getNote(let noteId), .putNote(let noteId):
            return "/api/v1/note/\(noteId)"
        case .getNotesByTicket(let ticketId):
            return "/api/v1/note/ticket/\(ticketId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNote, .getNotesByTicket:
            return .GET
        case .postNote:
            return .POST
        case .putNote:
            return .PUT
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .postNote, .getNote, .putNote, .getNotesByTicket:
            return .accessToken
        }
    }
}
