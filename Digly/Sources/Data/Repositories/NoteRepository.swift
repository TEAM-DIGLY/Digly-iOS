import Foundation

final class NoteRepository: NoteRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func createNote(ticketId: Int, contents: [String]) async throws -> Note {
        let request = PostNoteRequest(ticketId: ticketId, contents: contents)
        let response: PostNoteResponse = try await networkAPI.request(
            NoteEndpoint.postNote,
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func getNote(noteId: Int) async throws -> Note {
        let response: GetNoteResponse = try await networkAPI.request(NoteEndpoint.getNote(noteId))
        return response.toDomain()
    }

    func updateNote(noteId: Int, contents: [String]) async throws -> Note {
        let request = PutNoteRequest(contents: contents)
        let response: PutNoteResponse = try await networkAPI.request(
            NoteEndpoint.putNote(noteId),
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func getNotesByTicket(ticketId: Int, page: Int, size: Int) async throws -> NotesResult {
        let query: [String: String] = [
            "page": "\(page)",
            "size": "\(size)"
        ]

        let response: GetNotesByTicketResponse = try await networkAPI.request(
            NoteEndpoint.getNotesByTicket(ticketId),
            queryParameters: query
        )
        return response.toDomain()
    }
}
