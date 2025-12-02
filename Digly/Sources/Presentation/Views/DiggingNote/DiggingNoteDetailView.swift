import SwiftUI

struct DiggingNoteDetailView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject var viewModel: DiggingNoteDetailViewModel
    let ticket: Ticket
    
    init(
        ticket: Ticket,
        noteId: Int
    ) {
        self._viewModel = StateObject(wrappedValue: DiggingNoteDetailViewModel(noteId: noteId))
        self.ticket = ticket
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
            ScrollView(.vertical, showsIndicators: false) {
                headerSection
                
                ticketInfoSection
                    .padding(.bottom, 20)
                let isGuideMode: Bool = viewModel.note?.contents.first?.question != ""
                
                if let note = viewModel.note {
                    if viewModel.isEditMode {
                        if isGuideMode {
                            guideContent(note: note)
                        } else {
                            freeContent
                        }
                    } else {
                        noteContentSection(note: note)
                    }
                }
                
                Spacer().frame(height: 120)
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
        TitleBackNavBar(title: "노트 상세보기", isDarkMode: true) {
            Button(action: {
                viewModel.isMenuPresent = true
            }) {
                Image("detail")
            }
        }
        .padding(.bottom, 32)
    }
    
    private var ticketInfoSection: some View {
        VStack(spacing: 0) {
            // 관람일 정보
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
            
            // 티켓 이름
            Text(ticket.name)
                .fontStyle(.heading1)
                .foregroundStyle(.common100)
                .padding(.bottom, 10)
            
            // 감정 칩
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
    
    private func noteContentSection(note: Note) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(note.contents.enumerated()), id: \.offset) { index, content in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Q. \(content.question)")
                        .fontStyle(.label2)
                        .foregroundStyle(.opacityWhite500)
                    
                    Text(content.answer)
                        .fontStyle(.body2)
                        .foregroundStyle(.opacityWhite850)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                
                if index < note.contents.count - 1 {
                    Divider()
                        .background(Color.opacityWhite100)
                }
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
    
    private func guideContent(note: Note) -> some View {
        VStack(spacing: 0) {
            ForEach(note.contents, id: \.question) { content in
                Text(content.question)
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                
                //                ExpandableTextEditor(
                //                    text: viewModel.setAnswerBinding(for: question.question),
                //                    placeholder: "글을 작성해보세요"
                //                )
                //                .padding(.horizontal, 36)
                //                .padding(.bottom, 16)
                //                .transition(.opacity.animation(.mediumSpring))
            }
        }
    }
}

#Preview {
    DiggingNoteDetailView(
        ticket: Ticket.dummy,
        noteId: 1
    )
}
