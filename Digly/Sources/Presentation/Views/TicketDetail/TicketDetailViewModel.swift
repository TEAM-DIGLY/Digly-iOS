import Foundation
import Combine
import SwiftUI

@MainActor
class TicketDetailViewModel: ObservableObject {
    @Published var ticket: Ticket?
    @Published var isLoading: Bool = false
    @Published var hasEmotions: Bool = false
    @Published var isScreenshotTaken: Bool = false
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

                if let ticket = ticket {
                    hasEmotions = !ticket.feeling.isEmpty
                }

                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 상세 조회"))
            }
        }
    }
    
    func goToDiggingNote() {
    }

    func updateTicketEmotions(_ emotions: [EmotionColor]) {
        Task {
            do {
                guard let currentTicket = ticket else { return }

                let success = try await ticketUseCase.updateTicketEmotions(
                    ticketId: currentTicket.id,
                    emotions: emotions
                )

                if success {
                    ticket = Ticket(
                        id: currentTicket.id,
                        name: currentTicket.name,
                        time: currentTicket.time,
                        place: currentTicket.place,
                        count: currentTicket.count,
                        seatNumber: currentTicket.seatNumber,
                        price: currentTicket.price,
                        color: emotions,
                        feeling: currentTicket.feeling
                    )

                    hasEmotions = !emotions.isEmpty
                    ToastManager.shared.show(.success("감정이 성공적으로 등록되었습니다"))
                } else {
                    ToastManager.shared.show(.errorStringWithTask("감정 등록"))
                }
            } catch {
                ToastManager.shared.show(.errorStringWithTask("감정 등록"))
            }
        }
    }
    
}
