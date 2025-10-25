import Foundation
import Combine

final class NoteUseCase {
    private let noteRepository: NoteRepositoryProtocol
    
    init(noteRepository: NoteRepositoryProtocol = NoteRepository()) {
        self.noteRepository = noteRepository
    }
    
    func createNote(ticketId: Int, title: String, content: String) async throws -> Note {
        let request = CreateNoteRequest(ticketId: ticketId, title: title, content: content)
        return try await noteRepository.createNote(request: request)
    }
    
    func getNoteDetail(noteId: Int) async throws -> Note {
        return try await noteRepository.getNote(noteId: noteId)
    }
    
    func updateNote(noteId: Int, title: String, content: String) async throws -> Note {
        let request = UpdateNoteRequest(title: title, content: content)
        return try await noteRepository.updateNote(noteId: noteId, request: request)
    }
    
    func getNotesByTicketId(ticketId: Int, size: Int) async throws -> NotesResponse {
        let response = try await noteRepository.getNotesByTicket(ticketId: ticketId, size: size)
        return response.data
    }
    
    func validateNoteData(title: String, content: String) -> Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               title.count <= 100 &&
               content.count <= 1000
    }
}
