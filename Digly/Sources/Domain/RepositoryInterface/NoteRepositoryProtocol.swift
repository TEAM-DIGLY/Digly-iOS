import Foundation

protocol NoteRepositoryProtocol {
    func createNote(ticketId: Int, contents: [String]) async throws -> Note
    func getNote(noteId: Int) async throws -> Note
    func updateNote(noteId: Int, contents: [String]) async throws -> Note
    func getNotesByTicket(ticketId: Int, page: Int, size: Int) async throws -> NotesResult
}
