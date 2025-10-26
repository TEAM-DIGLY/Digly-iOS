import Foundation

protocol TicketRepositoryProtocol {
    func getTickets(startAt: Date?, endAt: Date?, page: Int?, size: Int?) async throws -> TicketsResult
    func getTicket(ticketId: Int) async throws -> Ticket
    func createTicket(ticket: Ticket) async throws -> Ticket
    func updateTicket(ticketId: Int, ticket: Ticket) async throws -> Ticket
    func deleteTicket(ticketId: Int, isOptional: Bool) async throws
}
