import Foundation
import Combine
import SwiftUI

class TicketDetailViewModel: ObservableObject {
    @Published var ticket: TicketModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let ticketId: String
    
    init(ticketId: String) {
        self.ticketId = ticketId
        loadTicketDetail()
    }
    
    // MARK: - Ticket Loading
    private func loadTicketDetail() {
        isLoading = true
        
        // 실제 구현에서는 API 호출을 통해 티켓 정보를 가져옵니다
        // 현재는 샘플 데이터에서 찾는 방식으로 구현
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.ticket = TicketModel.sampleData.first { ticket in
                ticket.id.uuidString == self.ticketId
            }
            
            if self.ticket == nil {
                self.errorMessage = "티켓을 찾을 수 없습니다."
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - Ticket Detail Helper
    func getTicketDetail() -> (title: String, userName: String, watchDate: String, watchNumber: Int, venue: String, seatInfo: String, price: String)? {
        guard let ticket = ticket else { return nil }
        
        return (
            title: ticket.title,
            userName: ticket.userName,
            watchDate: ticket.watchDate,
            watchNumber: ticket.watchNumber,
            venue: ticket.venue,
            seatInfo: ticket.seatInfo,
            price: ticket.price
        )
    }
    
    // MARK: - Actions
    func downloadTicket() {
        // 티켓 다운로드 액션
        print("티켓 다운로드 - TicketId: \(ticketId)")
    }
    
    func showTicketDetail() {
        // 티켓 상세보기 액션
        print("티켓 상세보기 - TicketId: \(ticketId)")
    }
    
    func goToDiggingNote() {
        // 디깅노트로 이동 액션
        print("디깅노트로 이동 - TicketId: \(ticketId)")
    }
} 