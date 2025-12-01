import Foundation

final class TicketRepository: TicketRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    // MARK: - 티켓 단일 조회
    func getTicket(ticketId: Int) async throws -> Ticket {
        let response: GetTicketResponse = try await networkAPI.request(TicketEndpoint.getTicket(ticketId))
        return response.toDomain()
    }
    
    // MARK: - 티켓 수정
    func updateTicket(ticketId: Int, ticket: Ticket) async throws -> Ticket {
        let request = PutTicketRequest(
            name: ticket.name,
            performanceTime: ticket.time.toISO8601String(),
            place: ticket.place,
            count: ticket.count,
            seatNumber: ticket.seatNumber,
            price: ticket.price,
            color: ticket.emotions.map { $0.rawValue },
            feeling: ticket.emotions.map { $0.rawValue }
        )

        let response: PutTicketResponse = try await networkAPI.request(
            TicketEndpoint.putTicket(ticketId),
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }
    
    // MARK: - 티켓 식제
    func deleteTicket(ticketId: Int, isOptional: Bool) async throws {
        let _: DeleteTicketResponse = try await networkAPI.request(
            TicketEndpoint.deleteTicket(ticketId),
            queryParameters: ["isOptional": String(isOptional)]
        )
    }
    
    // MARK: - 티켓 조회
    func getTickets(
        startAt: Date? = nil,
        endAt: Date? = nil,
        page: Int? = nil,
        size: Int? = nil,
        keyword: String? = nil
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

        if let keyword = keyword {
            queryParams["key"] = keyword
        }

        let response: GetTicketsResponse = try await networkAPI.request(
            TicketEndpoint.getTickets,
            queryParameters: queryParams
        )
        return response.toDomain()
    }

    // MARK: - 티켓 생성
    func createTicket(ticket: Ticket) async throws -> Ticket {
        let request = PostTicketRequest(
            name: ticket.name,
            performanceTime: ticket.time.toISO8601String(),
            place: ticket.place,
            count: ticket.count,
            seatNumber: ticket.seatNumber,
            price: ticket.price,
            color: ticket.emotions.map { $0.rawValue },
            feeling: ticket.emotions.map { $0.rawValue }
        )
        
        let response: PostTicketResponse = try await networkAPI.request(
            TicketEndpoint.postTicket,
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }
    
    // MARK: - 디깅노트 메인 화면 api
    // TODO: 연결
    func getTicketsForDiggingNote(page: Int, size: Int) async throws -> TicketDiggingNotesResult {
        let query: [String: String] = [
            "page": "\(page)",
            "size": "\(size)"
        ]

        let response: GetTicketsForDiggingNoteResponse = try await networkAPI.request(
            TicketEndpoint.getTicketsForDiggingNote,
            queryParameters: query
        )
        return response.toDomain()
    }
    
    // MARK: - 오늘의 관람, 즐거우셨나요? 화면 api
    // TODO: 연결
    func getTicketsComplete() async throws -> [TicketSummary] {
        let response: GetTicketsCompleteResponse = try await networkAPI.request(TicketEndpoint.getTicketsComplete)
        return response.toDomain()
    }
}
