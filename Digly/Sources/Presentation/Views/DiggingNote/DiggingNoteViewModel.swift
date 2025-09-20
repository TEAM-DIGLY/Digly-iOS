import Foundation
import Combine
import SwiftUI

@MainActor
class DiggingNoteViewModel: ObservableObject {
    @Published var ticketsWithNotes: [TicketWithNotes] = []
    @Published var isLoading: Bool = false
    @Published var expandedTicketId: Int? = nil

    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase

    init(
        ticketUseCase: TicketUseCase = TicketUseCase(),
        noteUseCase: NoteUseCase = NoteUseCase()
    ) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        fetchTicketsWithNotes()
    }

    func fetchTicketsWithNotes() {
        Task {
            do {
                isLoading = true

                // Fetch all tickets
                let ticketResponse = try await ticketUseCase.getAllTickets(
                    startDate: nil,
                    endDate: nil,
                    page: 0
                )

                var ticketsWithNotesData: [TicketWithNotes] = []

                // For each ticket, fetch its notes
                for ticketDTO in ticketResponse.tickets {
                    let ticket = ticketDTO.toDomain()

                    // TODO: Implement noteUseCase.getNotesByTicketId when available
                    // For now, using empty notes array
                    let notes: [Note] = []

                    let ticketWithNotes = TicketWithNotes(
                        ticket: ticket,
                        notes: notes,
                        lastNoteDate: notes.last?.id != nil ? Date() : nil
                    )

                    ticketsWithNotesData.append(ticketWithNotes)
                }

                // Sort by most recent note date, then by ticket date
                ticketsWithNotesData.sort { ticket1, ticket2 in
                    if let date1 = ticket1.lastNoteDate, let date2 = ticket2.lastNoteDate {
                        return date1 > date2
                    } else if ticket1.lastNoteDate != nil {
                        return true
                    } else if ticket2.lastNoteDate != nil {
                        return false
                    } else {
                        return ticket1.ticket.time > ticket2.ticket.time
                    }
                }

                ticketsWithNotes = ticketsWithNotesData
                isLoading = false

            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("노트 조회"))
            }
        }
    }

    func toggleExpanded(for ticketId: Int) {
        withAnimation(.mediumEaseOut) {
            if expandedTicketId == ticketId {
                expandedTicketId = nil
            } else {
                expandedTicketId = ticketId
            }
        }
    }

    func refreshData() {
        fetchTicketsWithNotes()
    }
}

struct TicketWithNotes: Identifiable {
    let ticket: Ticket
    let notes: [Note]
    let lastNoteDate: Date?

    var id: Int { ticket.id }
    var noteCount: Int { notes.count }

    var formattedLastNoteDate: String {
        guard let lastNoteDate = lastNoteDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: lastNoteDate)
    }
}
