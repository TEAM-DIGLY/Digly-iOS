import Foundation

final class NoteRepository: NoteRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func createNote(request: CreateNoteRequest) async throws -> Bool {
        let requestDTO = CreateNoteRequestDTO(
            ticketId: request.ticketId,
            contents: request.contents
        )

        let response:  = try await networkAPI.request(
            NoteEndpoint.postNote,
            parameters: requestDTO.toDictionary()
        )

        return response.statusc
    }

    func getNote(noteId: Int) async throws -> Note {
        let dto: GetNoteDTO = try await networkAPI.request(NoteEndpoint.getNote(noteId))
        return dto.toDomain()
    }

    func updateNote(noteId: Int, request: UpdateNoteRequest) async throws -> Note {
        let requestDTO = UpdateNoteRequestDTO(contents: request.contents)

        let dto: NoteDTO = try await networkAPI.request(
            NoteEndpoint.putNote(noteId),
            parameters: requestDTO.toDictionary()
        )

        return dto.toDomain()
    }

    func getNotesByTicket(ticketId: Int, page: Int, size: Int) async throws -> NotesResponse {
        let query: [String: String] = [
            "page": "\(page)",
            "size": "\(size)"
        ]

        let dto: GetNotesResponseDTO = try await networkAPI.request(
            NoteEndpoint.getNotesByTicket(ticketId),
            queryParameters: query
        )

        return dto.toDomain()
    }
}
