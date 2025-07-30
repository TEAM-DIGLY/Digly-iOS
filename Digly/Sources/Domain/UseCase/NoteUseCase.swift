import Foundation
import Combine

final class NoteUseCase {
    private let noteRepository: NoteRepositoryProtocol
    
    init(noteRepository: NoteRepositoryProtocol) {
        self.noteRepository = noteRepository
    }
    
    func createNote(ticketId: Int64, title: String, content: String) async throws -> Note {
        let request = CreateNoteRequest(ticketId: ticketId, title: title, content: content)
        return try await noteRepository.createNote(request: request)
    }
    
    func getNoteDetail(noteId: Int64) async throws -> Note {
        return try await noteRepository.getNote(noteId: noteId)
    }
    
    func updateNote(noteId: Int64, title: String, content: String) async throws -> Note {
        let request = UpdateNoteRequest(title: title, content: content)
        return try await noteRepository.updateNote(noteId: noteId, request: request)
    }
    
    func getNotesByTicket(ticketId: Int64, page: Int = 0, size: Int = 20) async throws -> TicketsResponse {
        return try await noteRepository.getNotesByTicket(ticketId: ticketId, page: page, size: size)
    }
    
    func validateNoteData(title: String, content: String) -> Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               title.count <= 100 &&
               content.count <= 1000
    }
    
//    func searchNotesWithKeyword(ticketId: Int64, keyword: String) -> AnyPublisher<TicketsResponse, APIError> {
//        // 현재 API 명세에는 검색 기능이 없지만, 향후 확장을 위한 메서드
//        return noteRepository.getNotesByTicket(ticketId: ticketId, page: 0, size: 100)
//            .map { response in
//                // 클라이언트 사이드에서 필터링 (향후 서버 사이드 검색으로 대체 가능)
//                let filteredTickets = response.tickets.filter { ticket in
//                    // Note 타입으로 변환 후 검색 로직 구현 필요
//                    return true // 임시 구현
//                }
//                return TicketsResponse(tickets: filteredTickets, pageInfo: response.pageInfo)
//            }
//            .eraseToAnyPublisher()
//    }
}
