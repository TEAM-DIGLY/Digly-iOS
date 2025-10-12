import Foundation
import Combine

final class TicketUseCase {
    private let ticketRepository: TicketRepository
    
    init(ticketRepository: TicketRepository = TicketRepository()) {
        self.ticketRepository = ticketRepository
    }
    
    func getBigTickets() async throws -> [Ticket] {
        let response: [TicketDTO] = try await ticketRepository.getTickets(size: 5).data.tickets
        return response.map{ $0.toDomain() }
    }
    
    func getAllTickets(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int = 0
    ) async throws -> TicketsResponse {
        return try await ticketRepository.getTickets(startAt: startDate,endAt: endDate, page: page).data
    }
    
    func getTicketDetail(ticketId: Int) async throws -> Ticket {
        let response: APIResponse<TicketDTO> = try await ticketRepository.getTicket(ticketId: ticketId)
        return response.data.toDomain()
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
    ) async throws -> Bool {
        let request = CreateTicketRequest(
            name: name,
            time: time,
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: EmotionColor.toRawValues(colors),
            feeling: feelings
        )
        
        let response: APIResponse<TicketDTO> = try await ticketRepository.createTicket(request: request)
        return response.status == 201
    }
    
    func updateTicket(
        ticketId: Int,
        name: String,
        time: Date,
        place: String,
        count: Int32,
        seatNumber: String? = nil,
        price: Int32? = nil,
        colors: [EmotionColor],
        feelings: [String]
    ) async throws -> Bool {
        let request = UpdateTicketRequest(
            name: name,
            time: time,
            place: place,
            count: count,
            seatNumber: seatNumber,
            price: price,
            color: EmotionColor.toRawValues(colors),
            feeling: feelings
        )
        let response: APIResponse<TicketDTO> = try await ticketRepository.updateTicket(ticketId: ticketId, request: request)
        return response.status == 200
    }
    
    func updateTicketEmotions(
        ticketId: Int,
        emotions: [EmotionColor]
    ) async throws -> Bool {
        // First get current ticket data
        let currentTicket = try await getTicketDetail(ticketId: ticketId)

        // Create update request with only emotions changed
        let request = UpdateTicketRequest(
            name: currentTicket.name,
            time: currentTicket.time,
            place: currentTicket.place,
            count: Int32(currentTicket.count),
            seatNumber: currentTicket.seatNumber,
            price: currentTicket.price.map(Int32.init),
            color: EmotionColor.toRawValues(emotions),
            feeling: currentTicket.feeling.map { $0.rawValue }
        )

        let response: APIResponse<TicketDTO> = try await ticketRepository.updateTicket(ticketId: ticketId, request: request)
        return response.status == 200
    }
}
