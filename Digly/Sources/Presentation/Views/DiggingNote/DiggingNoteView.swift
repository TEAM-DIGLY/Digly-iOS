import SwiftUI

struct DiggingNoteView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var viewModel = DiggingNoteViewModel()
    
    var body: some View {
        DGScreen(horizontalPadding: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40){
                    header
                    
                    if viewModel.ticketsWithNotes.isEmpty {
                        EmptyNoteView()
                    } else {
                        VStack(spacing: 32) {
                            ForEach(viewModel.ticketsWithNotes) { ticketWithNotes in
                                TicketNoteCardView(
                                    ticketWithNotes: ticketWithNotes,
                                    isExpanded: viewModel.expandedTicketId == ticketWithNotes.ticket.id,
                                    toggleExpand: {
                                        viewModel.toggleExpanded(for: ticketWithNotes.ticket.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
    
    private var header: some View {
            HStack {
                Text("\(authManager.nickname)'s\ndigging note")
                    .fontStyle(.title2)
                    .foregroundStyle(.common100)
                
                Spacer()
                
                Button(action: {
                }) {
                    VStack(spacing: 4) {
                        Image("plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("노트 추가")
                            .font(.label2)
                            .foregroundColor(.opacityWhite15)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                            .stroke(.opacityWhite75, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
    }
}

struct TicketNoteCardView: View {
    let ticketWithNotes: TicketWithNotes
    let isExpanded: Bool
    let toggleExpand: () -> Void

    private var ticketGradient: LinearGradient {
        let colors = ticketWithNotes.ticket.color.map { $0.color }
        if colors.isEmpty {
            return LinearGradient(colors: [.neutral15, .neutral25], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if colors.count == 1 {
            return LinearGradient(colors: [colors[0], colors[0].opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                expandedView
            } else {
                collapsedView
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ticketGradient)
        )
        .onTapGesture {
            toggleExpand()
        }
    }

    private var expandedView: some View {
        VStack(spacing: 0) {
            // Header with gradient background
            VStack(spacing: 0) {
                HStack {
                    Text(ticketWithNotes.ticket.name)
                        .fontStyle(.heading2)
                        .foregroundStyle(.common100)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Button(action: toggleExpand) {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.common100)
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)

                HStack {
                    Image("digging_note")
                        .resizable()
                        .frame(width: 12, height: 12)

                    Text("\(ticketWithNotes.noteCount)개의 노트")
                        .fontStyle(.caption1)
                        .foregroundStyle(.common100)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            // Notes content
            if !ticketWithNotes.notes.isEmpty {
                VStack(spacing: 16) {
                    ForEach(ticketWithNotes.notes) { note in
                        NoteContentItem(note: note)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
        }
    }

    private var collapsedView: some View {
        VStack(spacing: 12) {
            HStack {
                Text(ticketWithNotes.ticket.name)
                    .fontStyle(.heading2)
                    .foregroundStyle(.common100)
                    .multilineTextAlignment(.leading)

                Spacer()

                Button(action: toggleExpand) {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.common100)
                        .frame(width: 24, height: 24)
                }
            }

            HStack {
                HStack(spacing: 8) {
                    Image("digging_note")
                        .resizable()
                        .frame(width: 12, height: 12)

                    Text("\(ticketWithNotes.noteCount)개의 노트")
                        .fontStyle(.caption1)
                        .foregroundStyle(.common100)
                }

                Spacer()

                if !ticketWithNotes.formattedLastNoteDate.isEmpty {
                    HStack(spacing: 4) {
                        Text("최근 작성일")
                            .fontStyle(.caption1)
                            .foregroundStyle(.common100.opacity(0.7))

                        Circle()
                            .fill(.common100.opacity(0.7))
                            .frame(width: 2, height: 2)

                        Text(ticketWithNotes.formattedLastNoteDate)
                            .fontStyle(.caption1)
                            .foregroundStyle(.common100.opacity(0.7))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
}

struct EmptyNoteView: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.neutral55)

                Circle()
                    .fill(.neutral25)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "note.text")
                            .foregroundColor(.neutral55)
                            .font(.system(size: 20))
                    )
            }

            VStack(spacing: 8) {
                Text("아직 작성된 노트가 없어요.")
                    .fontStyle(.heading2)
                    .foregroundStyle(.common100)

                Text("관람한 기억을 안고\n특별한 기록을 시작해볼까요?")
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral55)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
        .padding(.horizontal, 24)
    }
}

struct NoteContentItem: View {
    let note: Note

    private var relativeTimeString: String {
        // This would typically calculate the relative time from note creation date
        // For now, returning placeholder values
        let timeOptions = ["어제", "3일 전", "7일 전", "2주 전", "1개월 전"]
        return timeOptions.randomElement() ?? "최근"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(relativeTimeString)
                .fontStyle(.caption1)
                .foregroundStyle(.neutral55)

            Text(note.content)
                .fontStyle(.body2)
                .foregroundStyle(.neutral25)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.common0.opacity(0.95))
        )
    }
}


#Preview {
    DiggingNoteView()
}
