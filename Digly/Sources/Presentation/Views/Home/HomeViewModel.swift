

import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var isLoading: Bool = false
    @Published var focusedTicketIndex: Int = 0
    @Published var notes: [Note] = []
    @Published var noteCount: Int = 0
    
    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var focusedTicket: Ticket? {
        tickets.isEmpty ? nil : tickets[safe: focusedTicketIndex]
    }
    
    init(ticketUseCase: TicketUseCase = TicketUseCase(ticketRepository: TicketRepository()),
         noteUseCase: NoteUseCase = NoteUseCase(noteRepository: NoteRepository())) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        loadTickets()
    }
    
    func loadTickets() {
        Task {
            isLoading = true
            do {
                let response = try await ticketUseCase.getAllTickets()
                tickets = response.data.tickets
                if !tickets.isEmpty {
                    await loadNotesForFocusedTicket()
                }
            } catch {
                print("Failed to load tickets: \(error)")
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
            isLoading = false
        }
    }
    
    func updateFocusedTicket(index: Int) {
        guard index != focusedTicketIndex && index >= 0 && index < tickets.count else { return }
        focusedTicketIndex = index
        Task {
            await loadNotesForFocusedTicket()
        }
    }
    
    private func loadNotesForFocusedTicket() async {
        guard let focusedTicket = focusedTicket else {
            notes = []
            noteCount = 0
            return
        }
        
        do {
            let response = try await noteUseCase.getNotesByTicket(ticketId: focusedTicket.id)
            notes = response.tickets.compactMap { ticket in
                // Assuming the API returns notes in the same format, need to properly map
                Note(id: ticket.id, title: ticket.name, content: ticket.place)
            }
            noteCount = notes.count
        } catch {
            print("Failed to load notes for ticket \(focusedTicket.id): \(error)")
            notes = []
            noteCount = 0
        }
    }
    
    // Calculate days remaining until performance
    func daysUntilPerformance(for ticket: Ticket) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let performanceDay = calendar.startOfDay(for: ticket.performanceTime)
        
        let components = calendar.dateComponents([.day], from: today, to: performanceDay)
        return components.day ?? 0
    }
    
    // Check if performance is today
    func isPerformanceToday(for ticket: Ticket) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(ticket.performanceTime, inSameDayAs: Date())
    }
}
