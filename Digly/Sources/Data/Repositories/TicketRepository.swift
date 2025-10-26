import Foundation

final class TicketRepository: TicketRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func getTickets(
        startAt: Date? = nil,
        endAt: Date? = nil,
        page: Int? = nil,
        size: Int? = nil
    ) async throws -> TicketsResult {
        var queryParams: [String: String] = [:]

        if let startAt = startAt {
            let formatter = ISO8601DateFormatter()
            queryParams["startAt"] = String(formatter.string(from: startAt).prefix(19))
        }

        if let endAt = endAt {
            let formatter = ISO8601DateFormatter()
            queryParams["endAt"] = String(formatter.string(from: endAt).prefix(19))
        }

        if let page = page {
            queryParams["page"] = String(page)
        }

        if let size = size {
            queryParams["size"] = String(size)
        }

        let response: GetTicketsResponse = try await networkAPI.request(
            TicketEndpoint.getTickets,
            queryParameters: queryParams
        )
        return response.toDomain()
    }

    func getTicket(ticketId: Int) async throws -> Ticket {
        let response: GetTicketResponse = try await networkAPI.request(TicketEndpoint.getTicket(ticketId))
        return response.toDomain()
    }

    func createTicket(ticket: Ticket) async throws -> Ticket {
        let request = PostTicketRequest(
            name: ticket.name,
            performanceTime: ticket.time.toISO8601String(),
            place: ticket.place,
            count: ticket.count,
            seatNumber: ticket.seatNumber,
            price: ticket.price,
            color: ticket.color.map { $0.rawValue },
            feeling: ticket.feeling.map { $0.rawValue }
        )

        let response: PostTicketResponse = try await networkAPI.request(
            TicketEndpoint.postTicket,
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func updateTicket(ticketId: Int, ticket: Ticket) async throws -> Ticket {
        let request = PutTicketRequest(
            name: ticket.name,
            performanceTime: ticket.time.toISO8601String(),
            place: ticket.place,
            count: ticket.count,
            seatNumber: ticket.seatNumber,
            price: ticket.price,
            color: ticket.color.map { $0.rawValue },
            feeling: ticket.feeling.map { $0.rawValue }
        )

        let response: PutTicketResponse = try await networkAPI.request(
            TicketEndpoint.putTicket(ticketId),
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func deleteTicket(ticketId: Int, isOptional: Bool) async throws {
        let _: DeleteTicketResponse = try await networkAPI.request(
            TicketEndpoint.deleteTicket(ticketId),
            queryParameters: ["isOptional": String(isOptional)]
        )
    }
}
