import Foundation

struct NoteGuideQuestion: Hashable {
    let question: String
    var answer: String = ""
}

struct PresetGuideQuestion: Identifiable {
    let question: String
    var id: String { question }
}
