import SwiftUI

@MainActor
class WriteNoteViewModel: ObservableObject {
    @Published var ticket: Ticket
    @Published var isGuideMode: Bool = true
    @Published var guideQuestions: [NoteGuideQuestion] = [
        NoteGuideQuestion(question: "이번 회차만의 특별한 에피소드가 있었나요?", answer: "asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkfls"),
        NoteGuideQuestion(question: "이번 뮤지컬만의 인상 깊었던 연출이 있었나요?", answer: "asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjfdjflasdkfls"),
    ]
    
    @Published var isQuestionBottomSheetPresent: Bool = false
    
    @Published var freeText: String = "asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;"
    
    @Published var expandedQuestionID: String? = "이번 뮤지컬만의 인상 깊었던 연출이 있었나요?"

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
        expandedQuestionID = nil
    }

    func addGuideQuestion(_ question: String) {
        guard guideQuestions.contains(where: { $0.question == question }) == false else { return }
        let newQuestion = NoteGuideQuestion(question: question)
        guideQuestions.append(newQuestion)
    }

    func removeGuideQuestion(id: String) {
        guideQuestions.removeAll { $0.question == id }
        if expandedQuestionID == id {
            expandedQuestionID = nil
        }
    }

    func updateAnswer(for id: String, answer: String) {
        if let index = guideQuestions.firstIndex(where: { $0.question == id }) {
            guideQuestions[index].answer = answer
        }
    }

    func toggleQuestionExpansion(id: String) {
        if expandedQuestionID == id {
            expandedQuestionID = nil
        } else {
            expandedQuestionID = id
        }
    }
}
