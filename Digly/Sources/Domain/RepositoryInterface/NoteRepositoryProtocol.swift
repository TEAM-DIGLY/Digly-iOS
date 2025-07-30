import Foundation

protocol NoteRepositoryProtocol {
    func createNote(request: CreateNoteRequest) async throws -> Note
    func getNote(noteId: Int64) async throws -> Note
    func updateNote(noteId: Int64, request: UpdateNoteRequest) async throws -> Note
    func getNotesByTicket(ticketId: Int64, page: Int?, size: Int?) async throws -> TicketsResponse
}