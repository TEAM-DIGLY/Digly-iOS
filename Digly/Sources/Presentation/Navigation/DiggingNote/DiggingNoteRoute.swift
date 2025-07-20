import Foundation

enum DiggingNoteRoute: BaseRoute {
    case diggingNote
    case writeDiggingNote
    
    var id: String {
        String(describing: self)
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .writeDiggingNote: true
        default: false
        }
    }
}

