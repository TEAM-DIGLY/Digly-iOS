import Foundation

protocol NoteRepositoryProtocol {
    func createNote(request: CreateNoteRequest) async throws -> Note
    func getNote(noteId: Int) async throws -> Note
    func updateNote(noteId: Int, request: UpdateNoteRequest) async throws -> Note
    func getNotesByTicket(ticketId: Int, page: Int, size: Int) async throws -> NotesResponse
}
