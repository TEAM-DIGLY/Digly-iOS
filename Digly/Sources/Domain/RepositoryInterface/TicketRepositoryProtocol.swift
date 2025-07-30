import Foundation

protocol TicketRepositoryProtocol {
    func getTickets(startAt: Date?, endAt: Date?, page: Int?, size: Int?) async throws -> TicketsResponse
    func getTicket(ticketId: Int64) async throws -> Ticket
    func createTicket(request: CreateTicketRequest) async throws -> Ticket
    func updateTicket(ticketId: Int64, request: UpdateTicketRequest) async throws -> Ticket
}