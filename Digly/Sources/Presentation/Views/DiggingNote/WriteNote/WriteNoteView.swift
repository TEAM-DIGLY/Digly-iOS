import SwiftUI

struct WriteNoteView: View {
    @StateObject private var viewModel: WriteNoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showQuestionBottomSheet = false

    init(ticket: Ticket) {
        _viewModel = StateObject(wrappedValue: WriteNoteViewModel(ticket: ticket))
    }

    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .common0) {
            headerSection
            
            Divider()
                .background(.opacityWhite200)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
                    ticketInfoSection
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    
                    // Content based on guide mode
                    if viewModel.isGuideMode {
                        guideContent
                    } else {
                        freeContent
                    }
                }
                .padding(.bottom, 100)
                
            }
        }
        .sheet(isPresented: $showQuestionBottomSheet) {
            QuestionSelectionBottomSheet(
                presetQuestions: PresetGuideQuestion.presets,
                onQuestionSelected: { question in
                    viewModel.addGuideQuestion(question)
                }
            )
        }
    }
    
    private var headerSection: some View {
        BackNavBarWithContent(isDarkMode: true) {
            HStack(spacing: 8) {
                Spacer()
                
                Text("작성 가이드")
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)
                
                Toggle("", isOn: Binding(
                    get: { viewModel.isGuideMode },
                    set: { newValue in
                        let popupType: PopupType = viewModel.isGuideMode ? .toggleGuideOff : .toggleGuideOn
                        PopupManager.shared.show(type: popupType) {
                            viewModel.toggleGuideMode()
                        }
                    }
                ))
                .toggleStyle(CustomToggleStyle())
                
                Spacer()
                
                Button(action: {
                    // TODO: 노트 저장
                }) {
                    Text("완료")
                        .fontStyle(.heading2)
                        .foregroundStyle(.common100)
                }
            }
        }
    }

    private var ticketInfoSection: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack(spacing: 4) {
                Text("관람일")
                    .fontStyle(.caption1)
                    .foregroundStyle(.opacityWhite700)

                Circle()
                    .fill(.opacityWhite700)
                    .frame(width: 2, height: 2)

                Text(viewModel.ticket.time.toInquiryDateString())
                    .fontStyle(.caption1)
                    .foregroundStyle(.opacityWhite700)
            }

            Text(viewModel.ticket.name)
                .fontStyle(.heading2)
                .foregroundStyle(.common100)
        }
    }

    private var guideContent: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.guideQuestions.enumerated()), id: \.element.id) { index, question in
                VStack(spacing: 0) {
                    if index > 0 {
                        Divider()
                            .background(.opacityWhite100)
                            .padding(.horizontal, 32)
                    }

                    HStack(alignment: .center) {
                        Text(question.question)
                            .fontStyle(.body2)
                            .foregroundStyle(.common100)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        Button(action: {
                            viewModel.removeGuideQuestion(id: question.id)
                        }) {
                            Image("chevron_down")
                                .renderingMode(.template)
                                .foregroundColor(.opacityWhite700)
                                .rotationEffect(.degrees(180))
                        }
                    }
                    .padding(.horizontal, 24)

                    ExpandableTextEditor(
                        text: Binding(
                            get: { question.answer },
                            set: { newValue in
                                viewModel.updateAnswer(for: question.id, answer: newValue)
                            }
                        ),
                        placeholder: "글을 작성해보세요"
                    )
                    .padding(.horizontal, 36)
                    .padding(.bottom, 16)
                }
            }

            Button(action: {
                showQuestionBottomSheet = true
            }) {
                Text("질문 추가하기")
                    .fontStyle(.body2)
                    .foregroundColor(.common100)
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .background(.opacityWhite100, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
    }

    private var freeContent: some View {
        VStack(spacing: 0) {
            ExpandableTextEditor(
                text: $viewModel.freeText,
                placeholder: "여운을 마음껏 표현해보세요"
            )
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }){
            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.opacityWhite700, lineWidth: 1)
                    .frame(width: 51, height: 24)
                
                Circle()
                    .fill(.common100)
                    .frame(width: 16, height: 16)
                    .padding(4)
                
                Text(configuration.isOn ? "ON" : "OFF")
                    .font(.caption1)
                    .foregroundColor(.common100)
                    .padding(.leading, 8)
                    .padding(.trailing, 4)
                    .frame(maxWidth: .infinity, alignment: configuration.isOn ? .leading : .trailing)
            }
            .frame(width: 51, height: 24)
        }
    }
}

struct ExpandableTextEditor: View {
    @Binding var text: String
    let placeholder: String

    @FocusState private var isFocused: Bool
    @State private var textHeight: CGFloat = 100

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .fontStyle(.body1)
                    .foregroundStyle(.opacityWhite400)
                    .padding(16)
            }

            TextEditor(text: $text)
                .fontStyle(.body1)
                .foregroundColor(.common100)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .focused($isFocused)
                .background(.opacityWhite50, in: RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(isFocused ? .opacityWhite600 : .opacityWhite100, lineWidth: 1)
                )
                .frame(minHeight: textHeight, maxHeight: isFocused ? .infinity : 278)
                .onChange(of: text) { _, _ in
                    updateHeight()
                }
        }
        .frame(height: isFocused ? nil : 278)
        .animation(.mediumSpring, value: isFocused)
    }

    private func updateHeight() {
        let size = CGSize(width: UIScreen.main.bounds.width - 72, height: .infinity)
        let estimatedHeight = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 15)],
            context: nil
        ).height

        textHeight = max(100, estimatedHeight + 40)
    }
}

@MainActor
class WriteNoteViewModel: ObservableObject {
    @Published var ticket: Ticket
    @Published var isGuideMode: Bool = true
    @Published var guideQuestions: [NoteGuideQuestion] = []
    @Published var freeText: String = "asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;asfd;ijdas;ajl;dsjflk;asdjflasdkflsda;jkfadsjfj;lsdakjflasdjf;klasdjfkldasjflasdjfklajsdklfjasdkl;fjlkasdjfkl;asdjfl;sdaijfl;axcvl;"

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
    }

    func addGuideQuestion(_ question: String) {
        let newQuestion = NoteGuideQuestion(question: question)
        guideQuestions.append(newQuestion)
    }

    func removeGuideQuestion(id: String) {
        guideQuestions.removeAll { $0.id == id }
    }

    func updateAnswer(for id: String, answer: String) {
        if let index = guideQuestions.firstIndex(where: { $0.id == id }) {
            guideQuestions[index].answer = answer
        }
    }
}

// Question Selection Bottom Sheet
struct QuestionSelectionBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    let presetQuestions: [PresetGuideQuestion]
    let onQuestionSelected: (String) -> Void

    @State private var selectedQuestion: String?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                ZStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("chevron_left")
                                .renderingMode(.template)
                                .foregroundColor(.opacityWhite850)
                        }

                        Spacer()
                    }

                    Text("질문 선택하기")
                        .fontStyle(.headline2)
                        .foregroundStyle(.opacityWhite800)
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(presetQuestions) { preset in
                            Button(action: {
                                selectedQuestion = preset.question
                            }) {
                                Text(preset.question)
                                    .fontStyle(.body2)
                                    .foregroundColor(.common100)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 64)
                                    .padding(.horizontal, 16)
                                    .background(
                                        selectedQuestion == preset.question
                                            ? .opacityWhite100.opacity(0.1)
                                            : .clear,
                                        in: RoundedRectangle(cornerRadius: 16)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                selectedQuestion == preset.question
                                                    ? .common100
                                                    : .opacityWhite100,
                                                lineWidth: selectedQuestion == preset.question ? 1.5 : 1
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
            }

            // 다음 버튼
            if selectedQuestion != nil {
                DGButton(
                    text: "다음",
                    type: .primaryDark,
                    disabled: false
                ) {
                    if let question = selectedQuestion {
                        onQuestionSelected(question)
                        dismiss()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .bottomSheetBackground.opacity(0),
                            .bottomSheetBackground
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                    .offset(y: 40)
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.mediumSpring, value: selectedQuestion)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bottomSheetBackground)
        .presentationDetents([.height(550)])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    WriteNoteView(ticket: Ticket(
        id: 1,
        name: "캣츠 내한공연 50주년",
        time: Date(),
        place: "샤롯데씨어터",
        count: 1,
        seatNumber: nil,
        price: nil,
        color: [.excited],
        feeling: [.excited]
    ))
}
