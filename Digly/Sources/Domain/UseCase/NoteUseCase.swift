import Foundation
import Combine

final class NoteUseCase {
    private let noteRepository: NoteRepositoryProtocol

    init(noteRepository: NoteRepositoryProtocol = NoteRepository()) {
        self.noteRepository = noteRepository
    }

    func createNote(ticketId: Int, contents: [String]) async throws -> Note {
        let request = CreateNoteRequest(ticketId: ticketId, contents: contents)
        return try await noteRepository.createNote(request: request)
    }

    func getNoteDetail(noteId: Int) async throws -> Note {
        return try await noteRepository.getNote(noteId: noteId)
    }

    func updateNote(noteId: Int, contents: [String]) async throws -> Note {
        let request = UpdateNoteRequest(contents: contents)
        return try await noteRepository.updateNote(noteId: noteId, request: request)
    }

    func getNotesByTicketId(ticketId: Int, page: Int = 0, size: Int = 20) async throws -> NotesResponse {
        return try await noteRepository.getNotesByTicket(ticketId: ticketId, page: page, size: size)
    }

    func validateNoteData(contents: [String]) -> Bool {
        // contents 배열이 비어있지 않고, 각 content가 유효한지 확인
        guard !contents.isEmpty else { return false }

        return contents.allSatisfy { content in
            !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            content.count <= 1000
        }
    }
}
