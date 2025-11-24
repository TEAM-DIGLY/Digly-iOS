import Foundation

protocol NoteRepositoryProtocol {
    func createNote(ticketId: Int, contents: [NoteContent]) async throws -> Note
    func getNote(noteId: Int) async throws -> Note
    func updateNote(noteId: Int, contents: [NoteContent]) async throws -> Note
    func getNotesByTicket(ticketId: Int, page: Int, size: Int) async throws -> NotesResult
    func deleteNote(noteId: Int) async throws
    func getNotesWithoutTicket(page: Int, size: Int) async throws -> NotesResult
}
