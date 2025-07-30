import Foundation

final class NoteRepository: NoteRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func createNote(request: CreateNoteRequest) async throws -> Note {
        return try await networkAPI.request(
            NoteEndpoint.postNote,
            parameters: request.toDictionary()
        )
    }
    
    func getNote(noteId: Int64) async throws -> Note {
        return try await networkAPI.request(NoteEndpoint.getNote(noteId))
    }
    
    func updateNote(noteId: Int64, request: UpdateNoteRequest) async throws -> Note {
        return try await networkAPI.request(
            NoteEndpoint.putNote(noteId),
            parameters: request.toDictionary()
        )
    }
    
    func getNotesByTicket(ticketId: Int64, page: Int?, size: Int?) async throws -> TicketsResponse {
        var queryParams: [String: String] = [:]
        
        if let page = page {
            queryParams["page"] = String(page)
        }
        
        if let size = size {
            queryParams["size"] = String(size)
        }
        
        return try await networkAPI.request(
            NoteEndpoint.getNotesByTicket(ticketId),
            queryParameters: queryParams
        )
    }
}