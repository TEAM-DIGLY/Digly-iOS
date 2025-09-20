import Foundation

protocol TicketRepositoryProtocol {
    func getTickets(startAt: Date?, endAt: Date?, page: Int?, size: Int?) async throws -> APIResponse<TicketsResponse>
    func getTicket(ticketId: Int) async throws -> APIResponse<TicketDTO>
    func createTicket(request: CreateTicketRequest) async throws -> APIResponse<TicketDTO>
    func updateTicket(ticketId: Int, request: UpdateTicketRequest) async throws -> APIResponse<TicketDTO>
}
