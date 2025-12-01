import SwiftUI

struct SelectNoteTicketView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject private var viewModel = SelectNoteTicketViewModel()
    
    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .common0) {
            BackNavWithTitle(title: "티켓 선택하기", backgroundColor: .common0)
                .padding(.horizontal, 24)
            
            if viewModel.tickets.isEmpty {
                Text("노트를 작성할 티켓이 없어요.\n먼저 티켓을 만들어 보세요.")
                    .font(.body2)
                    .foregroundStyle(.opacityWhite600)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 0),
                            GridItem(.flexible(), spacing: 0)
                        ],
                        spacing: 0
                    ) {
                        ForEach(viewModel.tickets) { ticket in
                            let isSelected = viewModel.selectedTicketId == ticket.id
                            
                            TicketCard(ticket: ticket, cardType: .note_small)
                                .opacity(isSelected ? 1.0 : 0.3)
                                .onTapGesture {
                                    viewModel.selectTicket(ticket)
                                }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 32)
                    .padding(.bottom, 140)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let selectedTicket = viewModel.selectedTicket {
                DGButton(text: "이 티켓으로 노트 추가하기", type: .primaryDark){
                    router.push(to: .writeNote(ticket: selectedTicket))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.mediumSpring, value: viewModel.selectedTicketId)
    }
}


#Preview {
    SelectNoteTicketView()
}
