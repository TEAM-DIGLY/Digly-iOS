import Foundation

@MainActor
class DiggingNoteViewModel: ObservableObject {
    @Published var diggingNoteTickets: [TicketDiggingNote] = []
    @Published var notesForTicket: [Note] = []
    @Published var expandedTicketId: Int? = nil
    @Published var isLoading: Bool = false
    
    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase
    
    init(
        ticketUseCase: TicketUseCase = TicketUseCase(),
        noteUseCase: NoteUseCase = NoteUseCase()
    ) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        fetchDiggingNoteTickets()
    }
    
    func setExpandedState(for ticketId: Int, isExpanded: Bool) {
        if isExpanded {
            Task {
                await fetchNotesForTicket(ticketId)
                expandedTicketId = ticketId
            }
        } else if expandedTicketId == ticketId {
            expandedTicketId = nil
            notesForTicket = []
        }
    }
    
    func fetchNotesForTicket(_ ticketId: Int) async {
        do {
            isLoading = true
            notesForTicket = []
            let response = try await noteUseCase.getNotesByTicketId(ticketId: ticketId)
            
            notesForTicket = response.notes
            isLoading = false
        } catch {
            isLoading = false
            ToastManager.shared.show(.errorStringWithTask("노트 조회"))
        }
    }
    
    
    func fetchDiggingNoteTickets() {
        Task {
            do {
                isLoading = true
                
                let ticketResponse = try await ticketUseCase.getTicketsForDiggingNote(page: 0)
                diggingNoteTickets = ticketResponse.tickets.sorted { lhs, rhs in
                    lhs.lastModifiedAt > rhs.lastModifiedAt
                }
                isLoading = false
                
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("노트 조회"))
            }
        }
    }
}
