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
    ) async throws -> APIResponse<TicketsResponse> {
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
        
        return try await networkAPI.request(TicketEndpoint.getTickets, queryParameters: queryParams)
    }
    
    func getTicket(ticketId: Int) async throws -> APIResponse<TicketDTO> {
        return try await networkAPI.request(TicketEndpoint.getTicket(ticketId))
    }
    
    func createTicket(request: CreateTicketRequest) async throws -> APIResponse<TicketDTO> {
        return try await networkAPI.request(TicketEndpoint.postTicket, parameters: request.toDictionary())
    }
    
    func updateTicket(ticketId: Int, request: UpdateTicketRequest) async throws -> APIResponse<TicketDTO> {
        return try await networkAPI.request(TicketEndpoint.putTicket(ticketId),parameters: request.toDictionary())
    }
}
