import Foundation
import Combine
import SwiftUI

@MainActor
class TicketBookViewModel: ObservableObject {
    @Published var bigTickets: [Ticket] = []
    @Published var tickets: [Ticket] = []
    
    @Published var startedDate: Date? = nil
    @Published var endDate: Date? = nil
    
    @Published var totalCnt: Int = 0
    @Published var username: String = "username"
    
    @Published var currentPage: Int = 0
    @Published var hasMorePages: Bool = true
    
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase
    
    init(
        ticketUseCase: TicketUseCase = TicketUseCase(),
        noteUseCase: NoteUseCase = NoteUseCase()
    ) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        initializeFetch()
        fetchBigTickets()
    }
    
    func changeSort() {
        print("정렬 방식 변경 후, 티켓 조회 api 재호출")
    }
    
    func initializeFetch() {
        currentPage = 0
        tickets = []
        hasMorePages = true
        
        Task {
            do {
                isLoading = true
                tickets = try await fetchTickets()
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 조회"))
            }
        }
    }
    
    func loadNextPage() {
        guard hasMorePages && !isLoadingMore else { return }
        currentPage += 1
        
        Task {
            do {
                isLoadingMore = true
                let newTickets = try await fetchTickets()
                tickets.append(contentsOf: newTickets)
                isLoadingMore = false
            } catch {
                isLoadingMore = false
                ToastManager.shared.show(.errorWithMessage("추가 캠페인을 불러오는 중 오류가 발생했습니다."))
                currentPage -= 1
            }
        }
    }
}

extension TicketBookViewModel {
    private func fetchBigTickets() {
        Task {
            do {
                isLoading = true
                bigTickets = try await ticketUseCase.getBigTickets()
                isLoading = false
                
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
        }
    }
    
    private func fetchTickets() async throws -> [Ticket] {
        let response = try await ticketUseCase.getAllTickets(
            startDate: startedDate,
            endDate: endDate,
            page: currentPage
        )
        totalCnt = response.pageInfo.totalElements
        hasMorePages = response.pageInfo.totalPages > currentPage + 1
        
        return response.tickets.map { $0.toDomain() }
    }
}
