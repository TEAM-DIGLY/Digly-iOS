import SwiftUI

struct DiggingNoteDetailView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject var viewModel: DiggingNoteDetailViewModel
    @FocusState var isFocused: Bool
    
    init(
        ticketId: Int,
        noteId: Int
    ) {
        self._viewModel = StateObject(wrappedValue: DiggingNoteDetailViewModel(noteId: noteId, ticketId: ticketId))
    }

    var body: some View {
        DGScreen(
            horizontalPadding: 0,
            backgroundColor: .common0,
            isLoading: viewModel.isLoading,
            onClick: {
                viewModel.isMenuPresent = false
            }
        ) {
            VStack(spacing: 0) {
                headerSection
                
                ScrollView(.vertical, showsIndicators: false) {
                    if let ticket = viewModel.ticket {
                        ticketInfoSection(ticket: ticket)
                            .padding(.bottom, 20)
                    }
                    viewModeContent
                    
                    Spacer().frame(height: 120)
                }
            }
        }
        .overlay(alignment: .top) {
            if viewModel.isMenuPresent {
                menuSection
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
        .animation(.mediumSpring, value: viewModel.isMenuPresent)
        .onChange(of: viewModel.noteDeleted) { _, deleted in
            if deleted {
                router.pop()
            }
        }
    }

    private var headerSection: some View {
        Group {
            if viewModel.isEditMode {
                BackNavBarWithContent(isDarkMode: true) {
                    HStack(spacing: 8) {
                        Spacer()

                        Text("노트 수정하기")
                            .fontStyle(.headline2)
                            .foregroundStyle(.opacityWhite800)

                        Spacer()

                        Button(action: {
                            Task {
                                _ = await viewModel.saveNote()
                            }
                        }) {
                            if viewModel.isSaving {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.common100)
                            } else {
                                Text("완료")
                                    .fontStyle(.headline2)
                                    .foregroundStyle(.common100)
                            }
                        }
                        .disabled(viewModel.isSaving)
                    }
                }
            } else {
                TitleBackNavBar(title: "노트 상세보기", isDarkMode: true) {
                    Button(action: {
                        viewModel.isMenuPresent = true
                    }) {
                        Image("detail")
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }

    private func ticketInfoSection(ticket: Ticket) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Text("관람일")
                    .fontStyle(.caption1)
                    .foregroundStyle(.neutral300)

                Circle()
                    .fill(.neutral700)
                    .frame(width: 2, height: 2)

                Text(ticket.time.toInquiryDateString())
                    .fontStyle(.caption1)
                    .foregroundStyle(.neutral300)
            }
            .padding(.bottom, 4)

            Text(ticket.name)
                .fontStyle(.heading1)
                .foregroundStyle(.common100)
                .padding(.bottom, 10)

            if !ticket.emotions.isEmpty {
                HStack(spacing: 8) {
                    ForEach(ticket.emotions.prefix(2), id: \.self) { emotion in
                        Text("#\(emotion.rawValue)")
                            .fontStyle(.caption1)
                            .foregroundStyle(.common100)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(emotion.color, in: RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    private var viewModeContent: some View {
        VStack(spacing: 0) {
            if let note = viewModel.note {
                let isGuideMode = note.contents.first?.question != ""

                if isGuideMode {
                    ForEach(Array(note.contents.enumerated()), id: \.offset) { index, content in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Q. \(content.question)")
                                .fontStyle(.label2)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.opacityWhite500)
                                .padding(.leading, 8)
                            
                            if viewModel.isEditMode {
                                ExpandableTextEditor(
                                    text: viewModel.getAnswerBinding(for: index),
                                    placeholder: "글을 작성해보세요"
                                )
                                .focused($isFocused)
                            } else {
                                Text(content.answer)
                                    .fontStyle(.body1)
                                    .foregroundStyle(.opacityWhite850)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical, 24)
                                    .padding(.horizontal, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.opacityWhite50)
                                    )
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.opacityWhite100, lineWidth: 1)
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                } else {
                    if viewModel.isEditMode {
                        ExpandableTextEditor(
                            text: viewModel.getAnswerBinding(for: 0),
                            placeholder: "여운을 마음껏 표현해보세요"
                        )
                        .focused($isFocused)
                        .padding(.horizontal, 24)
                    } else {
                        Text(note.contents.first?.answer ?? "")
                            .fontStyle(.body1)
                            .foregroundStyle(.opacityWhite850)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 24)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.opacityWhite50)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.opacityWhite100, lineWidth: 1)
                            }
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }

    private var menuSection: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.1).ignoresSafeArea()
                .onTapGesture {
                    viewModel.isMenuPresent = false
                }

            VStack(alignment: .center, spacing: 0) {
                Button(action: {
                    viewModel.isEditMode = true
                    viewModel.isMenuPresent = false
                }) {
                    Text("수정하기")
                        .font(.body2)
                        .foregroundStyle(.opacityWhite850)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }

                Divider()
                    .background(Color.opacityWhite100)

                Button(action: {
                    viewModel.isMenuPresent = false
                    PopupManager.shared.show(
                        .deleteNoteWarning {
                                viewModel.deleteNote { router.pop() }
                            }
                    )
                }) {
                    Text("삭제하기")
                        .font(.body2)
                        .foregroundStyle(.opacityWhite850)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
            }
            .background(Color(hex: "222222"), in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 12)
            .padding(.top, 64)
        }
    }
}

#Preview {
    DiggingNoteDetailView(
        ticketId: 2,
        noteId: 1
    )
    .environmentObject(DiggingNoteRouter())
}
