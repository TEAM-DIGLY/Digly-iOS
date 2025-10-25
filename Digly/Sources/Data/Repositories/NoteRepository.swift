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
    
    func getNote(noteId: Int) async throws -> Note {
        return try await networkAPI.request(NoteEndpoint.getNote(noteId))
    }
    
    func updateNote(noteId: Int, request: UpdateNoteRequest) async throws -> Note {
        return try await networkAPI.request(
            NoteEndpoint.putNote(noteId),
            parameters: request.toDictionary()
        )
    }
    
    func getNotesByTicket(ticketId: Int, size: Int) async throws -> APIResponse<NotesResponse> {
        let query: [String: String] = [
            "size": "\(size)"
        ]
        
        return try await networkAPI.request(NoteEndpoint.getNotesByTicket(ticketId), queryParameters: query)
    }
}
