import SwiftUI

@MainActor
class WriteNoteViewModel: ObservableObject {
    @Published var ticket: Ticket
    @Published var isGuideMode: Bool = true
    @Published var guideQuestions: [NoteGuideQuestion] = []
    
    
    @Published var freeText: String = ""
    @Published var selectedQuestion: String? = "이번 뮤지컬만의 인상 깊었던 연출이 있었나요?"
    @Published var isQuestionBottomSheetPresent: Bool = false

    init(ticket: Ticket) {
        self.ticket = ticket
    }

    func toggleGuideMode() {
        isGuideMode.toggle()
        // 모드 전환 시 내용 초기화
        if isGuideMode {
            freeText = ""
        } else {
            guideQuestions = []
        }
        selectedQuestion = nil
    }

    func addGuideQuestion(_ question: String) {
        guard guideQuestions.contains(where: { $0.question == question }) == false else { return }
        let newQuestion = NoteGuideQuestion(question: question)
        guideQuestions.append(newQuestion)
    }

    func removeGuideQuestion(id: String) {
        guideQuestions.removeAll { $0.question == id }
        if selectedQuestion == id {
            selectedQuestion = nil
        }
    }

    func updateAnswer(for id: String, answer: String) {
        if let index = guideQuestions.firstIndex(where: { $0.question == id }) {
            guideQuestions[index].answer = answer
        }
    }

    func toggleQuestionExpansion(id: String) {
        if selectedQuestion == id {
            selectedQuestion = nil
        } else {
            selectedQuestion = id
        }
    }

    // MARK: - Binding Management
    func setAnswerBinding(for question: String) -> Binding<String> {
        Binding(
            get: {
                self.guideQuestions.first(where: { $0.question == question })?.answer ?? ""
            },
            set: { newValue in
                if let index = self.guideQuestions.firstIndex(where: { $0.question == question }) {
                    self.guideQuestions[index].answer = newValue
                }
            }
        )
    }
}
