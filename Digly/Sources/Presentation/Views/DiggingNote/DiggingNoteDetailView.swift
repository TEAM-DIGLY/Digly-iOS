import SwiftUI

struct DiggingNoteDetailView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject var viewModel: DiggingNoteDetailViewModel
    
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
                    
                    if viewModel.isEditMode {
                        editModeContent
                    } else {
                        viewModeContent
                    }

                    Spacer().frame(height: 120)
                }
            }
        }
        .overlay(alignment: .top) {
            if viewModel.isMenuPresent {
                menuSection
            }
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
                                let didSave = await viewModel.saveNote()
                                if didSave {
                                    // 저장 성공
                                }
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
        .padding(.bottom, 32)
    }

    private func ticketInfoSection(ticket: Ticket) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Text("관람일")
                    .fontStyle(.label2)
                    .foregroundStyle(.opacityWhite500)

                Circle()
                    .fill(.opacityWhite500)
                    .frame(width: 2, height: 2)

                Text(ticket.time.toKoreanDateString())
                    .fontStyle(.label2)
                    .foregroundStyle(.opacityWhite500)
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
                            .fontStyle(.body1)
                            .foregroundStyle(emotion.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
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
                    // 가이드 모드: 질문-답변 형식
                    ForEach(Array(note.contents.enumerated()), id: \.offset) { index, content in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Q. \(content.question)")
                                .fontStyle(.label2)
                                .foregroundStyle(.opacityWhite500)

                            Text(content.answer)
                                .fontStyle(.body2)
                                .foregroundStyle(.opacityWhite850)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)

                        if index < note.contents.count - 1 {
                            Divider()
                                .background(Color.opacityWhite100)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.common0)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.opacityWhite50, lineWidth: 1)
                    }
                    .padding(.horizontal, 24)
                } else {
                    // 자유 모드: 답변만 표시
                    Text(note.contents.first?.answer ?? "")
                        .fontStyle(.body2)
                        .foregroundStyle(.opacityWhite850)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.common0)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.opacityWhite50, lineWidth: 1)
                        }
                        .padding(.horizontal, 24)
                }
            }
        }
    }

    private var editModeContent: some View {
        VStack(spacing: 0) {
            if let note = viewModel.note {
                let isGuideMode = note.contents.first?.question != ""

                if isGuideMode {
                    // 가이드 모드 편집
                    ForEach(Array(viewModel.editableContents.enumerated()), id: \.offset) { index, content in
                        VStack(alignment: .leading, spacing: 0) {
                            if !content.question.isEmpty {
                                Text("Q. \(content.question)")
                                    .fontStyle(.body2)
                                    .foregroundStyle(.common100)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 24)
                                    .padding(.top, index == 0 ? 0 : 16)
                            }

                            ExpandableTextEditor(
                                text: viewModel.getAnswerBinding(for: index),
                                placeholder: "글을 작성해보세요"
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, content.question.isEmpty ? 0 : 8)
                        }
                    }
                } else {
                    // 자유 모드 편집
                    ExpandableTextEditor(
                        text: viewModel.getAnswerBinding(for: 0),
                        placeholder: "여운을 마음껏 표현해보세요"
                    )
                    .padding(.horizontal, 24)
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
                        .frame(height: 52)
                }

                Divider()
                    .background(Color.opacityWhite100)

                Button(action: {
                    viewModel.showDeleteConfirmation()
                    viewModel.isMenuPresent = false
                }) {
                    Text("삭제하기")
                        .font(.body2)
                        .foregroundStyle(.opacityWhite850)
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
