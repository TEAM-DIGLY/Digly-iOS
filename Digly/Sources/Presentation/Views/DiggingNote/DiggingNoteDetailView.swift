import SwiftUI

struct DiggingNoteDetailView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject var viewModel: DiggingNoteDetailViewModel = DiggingNoteDetailViewModel()

    let ticket: Ticket
    let noteId: Int

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

                if let note = viewModel.note {
                    VStack(spacing: 0) {
                        ticketInfoSection
                            .padding(.bottom, 20)

                        noteContentSection(note: note)
                    }
                }

                Spacer().frame(height: 120)
            }
        }
        .overlay(alignment: .top) {
            if let note = viewModel.note, viewModel.isMenuPresent {
                menuSection(note)
            }
        }
        .animation(.mediumSpring, value: viewModel.isMenuPresent)
        .onAppear {
            viewModel.getNoteDetail(noteId: noteId)
        }
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

    private func menuSection(_ note: Note) -> some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.1).ignoresSafeArea()
                .onTapGesture {
                    viewModel.isMenuPresent = false
                }

            VStack(alignment: .center, spacing: 0) {
                Button(action: {
                    router.push(to: .noteDetail(ticket: ticket, noteId: note.id))
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
        ticket: Ticket.dummy,
        noteId: 1
    )
}
