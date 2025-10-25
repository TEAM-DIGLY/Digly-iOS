import SwiftUI

struct DiggingNoteView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var viewModel = DiggingNoteViewModel()
    
    @State private var selectedTicket: Ticket? = nil

    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .bgDark) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40){
                    header
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                    
                    if viewModel.ticketsWithNotes.isEmpty {
                        VStack(spacing: 24) {
                            Image("warning-digly")
                            
                            VStack(spacing: 12) {
                                Text("아직 작성된 노트가 없어요.")
                                
                                Text("관람한 기억을 안고\n특별한 기록을 시작해볼까요?")
                                    .multilineTextAlignment(.center)
                            }
                            .fontStyle(.body2)
                            .foregroundStyle(.common100)
                        }
                        .padding(.top, 160)
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
                        .animation(.fastSpring, value: viewModel.expandedTicketId)
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
                router.push(to: .ticketSelection)
            }) {
                VStack(spacing: 4) {
                    Image("plus")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("노트 추가")
                        .font(.label2)
                        .foregroundColor(.opacityWhite800)
                }
                .padding(.horizontal, 16)
                .frame(height: 72)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.clear)
                        .stroke(.opacityWhite200, lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    DiggingNoteView()
}
