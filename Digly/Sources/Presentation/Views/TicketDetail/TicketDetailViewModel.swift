import Foundation
import Combine
import SwiftUI

@MainActor
class TicketDetailViewModel: ObservableObject {
    @Published var ticket: Ticket? = Ticket(
        id: 1,
        name: "프랑켄슈타인",
        time: Date(),
        place: "블루스퀘어 신한카드홀",
        count: 24,
        seatNumber: "@4",
        price: 20000,
        emotions: [.excited, .relaxed],
        notes: []
    )
    
    @Published var isLoading: Bool = false
    @Published var isScreenshotTaken: Bool = false
    @Published var isEmotionSheetPresent = false
    
    @Published var isMenuPresent = false
    @Published var isEditViewPresent = false
    @Published var ticketDeleted = false
    
    let ticketUseCase: TicketUseCase
    
    init(
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.ticketUseCase = ticketUseCase
    }
    
    func getTicketDetail(id: Int) {
        Task {
            do {
                isLoading = true
                ticket = try await ticketUseCase.getTicketDetail(ticketId: id)
                
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 상세 조회"))
            }
        }
    }
    
    func updateTicketEmotions(_ emotions: [Emotion]) {
        Task {
            do {
                guard let currentTicket = ticket else { return }

                ticket = try await ticketUseCase.updateTicketEmotions(
                    ticketId: currentTicket.id,
                    emotions: emotions
                )

                ToastManager.shared.show(.success("감정이 성공적으로 등록되었습니다"))
            } catch {
                ToastManager.shared.show(.errorStringWithTask("감정 등록"))
            }
        }
    }

    func showDeleteConfirmation() {
        guard let currentTicket = ticket else { return }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        let dateString = formatter.string(from: currentTicket.time)

        PopupManager.shared.show(
            .deleteTicketWarning(
                ticketName: currentTicket.name,
                date: dateString,
                onClick: {
                    self.deleteTicket()
                }
            )
        )
    }

    private func deleteTicket(withNotes: Bool = false) {
        Task {
            do {
                guard let currentTicket = ticket else { return }

                isLoading = true
                try await ticketUseCase.deleteTicket(ticketId: currentTicket.id, withNotes: withNotes)

                await MainActor.run {
                    isLoading = false
                    ticketDeleted = true
                    ToastManager.shared.show(.success("티켓이 삭제되었습니다"))
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    ToastManager.shared.show(.errorStringWithTask("티켓 삭제"))
                }
            }
        }
    }
}
