import SwiftUI

@MainActor
class WriteNoteViewModel: ObservableObject {
    @Published var ticket: Ticket
    @Published var isGuideMode: Bool = true
    @Published var guideQuestions: [NoteGuideQuestion] = []
    
    
    @Published var freeText: String = ""
    @Published var selectedQuestion: String? = "이번 뮤지컬만의 인상 깊었던 연출이 있었나요?"
    @Published var isQuestionBottomSheetPresent: Bool = false
    @Published var isSaving: Bool = false

    private let noteUseCase: NoteUseCase
    private let freeWritingQuestionTitle = "여운을 마음껏 표현해보세요"

    init(ticket: Ticket, noteUseCase: NoteUseCase = NoteUseCase()) {
        self.ticket = ticket
        self.noteUseCase = noteUseCase
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

    func saveNote() async -> Bool {
        guard !isSaving else { return false }

        let contents = buildNoteContents()

        guard noteUseCase.validateNoteData(contents: contents) else {
            ToastManager.shared.show(.errorWithMessage("노트 내용을 입력하고 1,000자 이하로 작성해주세요."))
            return false
        }

        isSaving = true

        do {
            _ = try await noteUseCase.createNote(ticketId: ticket.id, contents: contents)
            ToastManager.shared.show(.success("노트가 저장되었어요."))
            isSaving = false
            return true
        } catch {
            ToastManager.shared.show(.error(error))
            isSaving = false
            return false
        }
    }

    private func buildNoteContents() -> [NoteContent] {
        if isGuideMode {
            return guideQuestions
                .map {
                    NoteContent(
                        question: $0.question,
                        answer: $0.answer.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                }
                .filter { !$0.answer.isEmpty }
        } else {
            let trimmed = freeText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return [] }
            return [NoteContent(question: "", answer: trimmed)]
        }
    }
}
