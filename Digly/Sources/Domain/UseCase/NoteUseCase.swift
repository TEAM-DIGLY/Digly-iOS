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
    
    func getNotesByTicket(ticketId: Int, page: Int = 0, size: Int = 5) async throws -> NotesResponse {
        return try await noteRepository.getNotesByTicket(ticketId: ticketId, page: page, size: size)
    }
    
    func validateNoteData(title: String, content: String) -> Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               title.count <= 100 &&
               content.count <= 1000
    }
}
