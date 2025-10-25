import Foundation

struct NoteGuideQuestion: Identifiable, Hashable {
    let id: String
    let question: String
    var answer: String = ""

    init(id: String = UUID().uuidString, question: String, answer: String = "") {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

struct PresetGuideQuestion: Identifiable {
    let id: String = UUID().uuidString
    let question: String

    static let presets: [PresetGuideQuestion] = [
        PresetGuideQuestion(question: "이번 회차만의 특별한 에피소드가 있었나요?"),
        PresetGuideQuestion(question: "이번 뮤지컬만의 인상 깊었던 연출이 있었나요?"),
        PresetGuideQuestion(question: "집 가는 길 내 귓가를 맴도는 넘버는 무엇이었나요?"),
        PresetGuideQuestion(question: "이번 회차 배우들의 캐스트별 특징이 있었나요?"),
        PresetGuideQuestion(question: "좋아하는 배우의 캐릭터 비주얼과 의상은 어땠나요?")
    ]
}
