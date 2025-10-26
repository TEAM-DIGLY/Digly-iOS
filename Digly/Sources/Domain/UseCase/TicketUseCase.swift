import Foundation
import Combine

final class TicketUseCase {
    private let ticketRepository: TicketRepositoryProtocol

    init(ticketRepository: TicketRepositoryProtocol = TicketRepository()) {
        self.ticketRepository = ticketRepository
    }

    func getBigTickets() async throws -> [Ticket] {
        let result = try await ticketRepository.getTickets(startAt: nil, endAt: nil, page: nil, size: 5)
        return result.tickets
    }

    func getAllTickets(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int = 0
    ) async throws -> TicketsResult {
        return try await ticketRepository.getTickets(startAt: startDate, endAt: endDate, page: page, size: nil)
    }

    func getTicketDetail(ticketId: Int) async throws -> Ticket {
        return try await ticketRepository.getTicket(ticketId: ticketId)
    }

    func createTicket(
        name: String,
        time: Date,
        place: String,
        count: Int,
        seatNumber: String? = nil,
        price: Int? = nil,
        colors: [EmotionColor],
        feelings: [String]
    ) async throws -> Ticket {
        let feelingEnums = feelings.compactMap { Feeling(rawValue: $0) }
        let ticket = Ticket(
            id: 0,
            name: name,
            time: time,
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: colors,
            feeling: feelingEnums
        )
        return try await ticketRepository.createTicket(ticket: ticket)
    }

    func updateTicket(
        ticketId: Int,
        name: String,
        time: Date,
        place: String,
        count: Int,
        seatNumber: String? = nil,
        price: Int? = nil,
        colors: [EmotionColor],
        feelings: [String]
    ) async throws -> Ticket {
        let feelingEnums = feelings.compactMap { Feeling(rawValue: $0) }
        let ticket = Ticket(
            id: ticketId,
            name: name,
            time: time,
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: colors,
            feeling: feelingEnums
        )
        return try await ticketRepository.updateTicket(ticketId: ticketId, ticket: ticket)
    }

    func updateTicketEmotions(
        ticketId: Int,
        emotions: [EmotionColor]
    ) async throws -> Ticket {
        // First get current ticket data
        let currentTicket = try await getTicketDetail(ticketId: ticketId)

        // Create update ticket with only emotions changed
        let updatedTicket = Ticket(
            id: currentTicket.id,
            name: currentTicket.name,
            time: currentTicket.time,
            place: currentTicket.place,
            count: currentTicket.count,
            seatNumber: currentTicket.seatNumber,
            price: currentTicket.price,
            color: emotions,
            feeling: currentTicket.feeling
        )

        return try await ticketRepository.updateTicket(ticketId: ticketId, ticket: updatedTicket)
    }

    func deleteTicket(ticketId: Int, withNotes: Bool) async throws {
        try await ticketRepository.deleteTicket(ticketId: ticketId, isOptional: withNotes)
    }
}
