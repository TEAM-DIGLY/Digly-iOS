import SwiftUI

struct DiggingNoteView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var viewModel = DiggingNoteViewModel()
    
    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .bgDark) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40){
                    header
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                    
                    if viewModel.ticketsWithNotes.isEmpty {
                        EmptyNoteView()
                    } else {
                        VStack(spacing: 32) {
                            ForEach(viewModel.ticketsWithNotes) { ticketWithNotes in
                                TicketNoteCardView(
                                    ticketWithNotes: ticketWithNotes,
                                    isExpanded: Binding(
                                        get: { viewModel.expandedTicketId == ticketWithNotes.ticket.id },
                                        set: { newValue in
                                            viewModel.setExpandedState(for: ticketWithNotes.ticket.id, isExpanded: newValue)
                                        }
                                    )
                                )
                            }
                        }
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

#Preview {
    DiggingNoteView()
}
