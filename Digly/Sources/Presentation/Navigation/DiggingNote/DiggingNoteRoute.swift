import Foundation

enum DiggingNoteRoute: BaseRoute {
    case diggingNote
    case ticketSelection
    case writeNote(ticket: Ticket)
    case noteDetail(ticket: Ticket, noteId: Int)

    var id: String {
        String(describing: self)
    }

    var disableSwipeBack: Bool {
        switch self {
        case .writeNote: true
        default: false
        }
    }
}

