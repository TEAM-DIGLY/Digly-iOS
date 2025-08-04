import Foundation

final class TicketRepository: TicketRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getTickets(startAt: Date?, endAt: Date?, page: Int?, size: Int?) async throws -> APIResponse<TicketsResponse> {
        var queryParams: [String: String] = [:]
        
        if let startAt = startAt {
            let formatter = ISO8601DateFormatter()
            queryParams["startAt"] = formatter.string(from: startAt)
        }
        
        if let endAt = endAt {
            let formatter = ISO8601DateFormatter()
            queryParams["endAt"] = formatter.string(from: endAt)
        }
        
        if let page = page {
            queryParams["page"] = String(page)
        }
        
        if let size = size {
            queryParams["size"] = String(size)
        }
        
        return try await networkAPI.request(
            TicketEndpoint.getTickets,
            queryParameters: queryParams
        )
    }
    
    func getTicket(ticketId: Int64) async throws -> Ticket {
        return try await networkAPI.request(TicketEndpoint.getTicket(ticketId))
    }
    
    func createTicket(request: CreateTicketRequest) async throws -> Ticket {
        return try await networkAPI.request(
            TicketEndpoint.postTicket,
            parameters: request.toDictionary()
        )
    }
    
    func updateTicket(ticketId: Int64, request: UpdateTicketRequest) async throws -> Ticket {
        return try await networkAPI.request(
            TicketEndpoint.putTicket(ticketId),
            parameters: request.toDictionary()
        )
    }
}
