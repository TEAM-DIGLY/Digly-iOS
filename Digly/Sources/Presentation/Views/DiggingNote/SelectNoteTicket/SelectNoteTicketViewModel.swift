import Foundation

@MainActor
class SelectNoteTicketViewModel: ObservableObject {
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
                emotions: [.excited, .glad]
            ),
            Ticket(
                id: 2,
                name: "오페라의 유령",
                time: calendar.date(byAdding: .day, value: -20, to: today)!,
                place: "블루스퀘어",
                count: 2,
                seatNumber: "B-15",
                price: 150000,
                emotions: [.glad]
            ),
            Ticket(
                id: 3,
                name: "레미제라블",
                time: calendar.date(byAdding: .day, value: -30, to: today)!,
                place: "샤롯데씨어터",
                count: 3,
                seatNumber: "C-20",
                price: 130000,
                emotions: [.relaxed, .satisfied]
            ),
            Ticket(
                id: 4,
                name: "위키드",
                time: calendar.date(byAdding: .day, value: -40, to: today)!,
                place: "디큐브아트센터",
                count: 4,
                seatNumber: "D-8",
                price: 140000,
                emotions: [.glad]
            )
        ]
    }
}
