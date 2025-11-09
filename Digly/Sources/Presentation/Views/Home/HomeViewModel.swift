

import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var isLoading: Bool = false
    @Published var focusedTicketIndex: Int = 0
    @Published var ticketNotes: [Note] = []
    
    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase
    
    var focusedTicket: Ticket? {
        tickets.isEmpty ? nil : tickets[safe: focusedTicketIndex]
    }
    
    init(ticketUseCase: TicketUseCase = TicketUseCase(ticketRepository: TicketRepository()),
         noteUseCase: NoteUseCase = NoteUseCase(noteRepository: NoteRepository())) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        
        fetchTickets()
        
    }
    
    private func fetchTickets() {
        Task {
            isLoading = true
            do {
                let response = try await ticketUseCase.getAllTickets()
                tickets = response.tickets
                
                if !tickets.isEmpty {
                    focusedTicketIndex = 0
//                    await loadNotesForFocusedTicket()
                }
            } catch {
                print("Failed to load tickets: \(error)")
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
            isLoading = false
        }
    }
    
//    func loadNotesForFocusedTicket() async {
//        guard let focusedTicket = focusedTicket else {
//            ticketNotes = []
//            return
//        }
//        
//        do {
//            let response = try await noteUseCase.getNotesByTicketId(ticketId: focusedTicket.id)
//            ticketNotes = response.notes
//        } catch {
//            print("Failed to load notes for ticket \(focusedTicket.id): \(error)")
//            ticketNotes = []
//        }
//    }
    
    func updateFocusedTicket(index: Int) {
        guard index != focusedTicketIndex && index >= 0 && index < tickets.count else { return }
        focusedTicketIndex = index
        
        Task {
//            await loadNotesForFocusedTicket()
        }
    }
    
    // Computed property to get note count for focused ticket
    var noteCount: Int {
        ticketNotes.count
    }
    
    // Calculate days remaining until performance
    func daysUntilPerformance(for ticket: Ticket) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let performanceDay = calendar.startOfDay(for: ticket.time)
        
        let components = calendar.dateComponents([.day], from: today, to: performanceDay)
        return components.day ?? 0
    }
    
    // Check if performance is today
    func isPerformanceToday(for ticket: Ticket) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(ticket.time, inSameDayAs: Date())
    }
}
