import Foundation
import Combine

final class TicketUseCase {
    private let ticketRepository: TicketRepositoryProtocol
    
    init(ticketRepository: TicketRepositoryProtocol) {
        self.ticketRepository = ticketRepository
    }
    
    func getAllTickets(startDate: Date? = nil, endDate: Date? = nil, page: Int = 0, size: Int = 20) async throws -> APIResponse<TicketsResponse> {
        return try await ticketRepository.getTickets(startAt: startDate, endAt: endDate, page: page, size: size)
    }
    
    func getTicketDetail(ticketId: Int64) async throws -> Ticket {
        return try await ticketRepository.getTicket(ticketId: ticketId)
    }
    
    func createTicket(
        name: String,
        performanceTime: Date,
        place: String,
        count: Int32,
        seatNumber: String? = nil,
        price: Int32? = nil,
        colors: [String],
        feelings: [String]
    ) async throws -> Ticket {
        let request = CreateTicketRequest(
            name: name,
            performanceTime: performanceTime,
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: colors,
            feeling: feelings
        )
        
        return try await ticketRepository.createTicket(request: request)
    }
    
    func updateTicket(
        ticketId: Int64,
        name: String,
        performanceTime: Date,
        place: String,
        count: Int32,
        seatNumber: String? = nil,
        price: Int32? = nil,
        colors: [String],
        feelings: [String]
    ) async throws -> Ticket {
        let request = UpdateTicketRequest(
            name: name,
            performanceTime: performanceTime,
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: colors,
            feeling: feelings
        )
        
        return try await ticketRepository.updateTicket(ticketId: ticketId, request: request)
    }
    
    func getUpcomingTickets() async throws -> APIResponse<TicketsResponse> {
        return try await ticketRepository.getTickets(startAt: Date(), endAt: nil, page: 0, size: 10)
    }
    
    func getPastTickets() async throws -> APIResponse<TicketsResponse> {
        return try await ticketRepository.getTickets(startAt: nil, endAt: Date(), page: 0, size: 20)
    }
    
    func validateTicketData(name: String, place: String, performanceTime: Date) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !place.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        performanceTime > Date()
    }
}
