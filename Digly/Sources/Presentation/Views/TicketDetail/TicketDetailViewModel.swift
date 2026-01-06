import Foundation
import Combine
import SwiftUI

@MainActor
class TicketDetailViewModel: ObservableObject {
    @Published var ticket: Ticket? = nil
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

    func deleteTicket(onSuccess: @escaping () -> Void) {
        Task {
            do {
                guard let currentTicket = ticket else { return }

                isLoading = true
                try await ticketUseCase.deleteTicket(ticketId: currentTicket.id, withNotes: true)

                await MainActor.run {
                    isLoading = false
                    onSuccess()
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
