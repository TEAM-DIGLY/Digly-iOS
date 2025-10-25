import SwiftUI

struct NoteTicketSelectionView: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @StateObject private var viewModel = NoteTicketSelectionViewModel()
    
    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .common0) {
            VStack(spacing: 0) {
                BackNavWithTitle(title: "티켓 선택하기", backgroundColor: .common0)
                    .padding(.horizontal, 24)
                
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
                            
                            TicketCardView(ticket: ticket, cardType: .note_small)
                                .opacity(isSelected || viewModel.selectedTicketId == nil ? 1.0 : 0.3)
                                .onTapGesture {
                                    viewModel.selectTicket(ticket)
                                }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 32)
                    .padding(.bottom, 140)
                }
                
                Spacer()
            }
            .overlay(alignment: .bottom) {
                if viewModel.selectedTicketId != nil, let selectedTicket = viewModel.selectedTicket {
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
}

@MainActor
class NoteTicketSelectionViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var selectedTicketId: Int? = nil
    
    var selectedTicket: Ticket? {
        tickets.first { $0.id == selectedTicketId }
    }
    
    init() { loadTickets() }
    
    func selectTicket(_ ticket: Ticket) {
        if selectedTicketId == ticket.id {
            selectedTicketId = nil
        } else {
            selectedTicketId = ticket.id
        }
    }
    
    func loadTickets() {
        // TODO: API 호출로 티켓 목록 가져오기
        // 임시 데이터
        tickets = createSampleTickets()
    }
    
    private func createSampleTickets() -> [Ticket] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            Ticket(
                id: 1,
                name: "캣츠 내한공연 50주년",
                time: calendar.date(byAdding: .day, value: -10, to: today)!,
                place: "샤롯데씨어터",
                count: 1,
                seatNumber: "A-12",
                price: 120000,
                color: [.excited, .glad],
                feeling: [.excited, .joyful]
            ),
            Ticket(
                id: 2,
                name: "오페라의 유령",
                time: calendar.date(byAdding: .day, value: -20, to: today)!,
                place: "블루스퀘어",
                count: 2,
                seatNumber: "B-15",
                price: 150000,
                color: [.satisfied],
                feeling: [.satisfied, .peaceful]
            ),
            Ticket(
                id: 3,
                name: "레미제라블",
                time: calendar.date(byAdding: .day, value: -30, to: today)!,
                place: "샤롯데씨어터",
                count: 3,
                seatNumber: "C-20",
                price: 130000,
                color: [.relaxed, .satisfied],
                feeling: [.peaceful]
            ),
            Ticket(
                id: 4,
                name: "위키드",
                time: calendar.date(byAdding: .day, value: -40, to: today)!,
                place: "디큐브아트센터",
                count: 4,
                seatNumber: "D-8",
                price: 140000,
                color: [.glad],
                feeling: [.joyful]
            )
        ]
    }
}

#Preview {
    NoteTicketSelectionView()
}
