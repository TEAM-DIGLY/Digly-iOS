import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var isLoading: Bool = false
    @Published var ddayTickets: [TicketSummary] = []
    @Published var selectedDdayTicketId: Int = 0

    // Popup states
    @Published var isEmotionSheetPresent: Bool = false
    @Published var isTutorialPresent: Bool = false

    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase
    private let onboardingUseCase: OnboardingUseCase

    init(ticketUseCase: TicketUseCase = TicketUseCase(),
         noteUseCase: NoteUseCase = NoteUseCase(),
         onboardingUseCase: OnboardingUseCase = OnboardingUseCase()) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        self.onboardingUseCase = onboardingUseCase

        fetchTickets()
        checkTutorialVisibility()
    }
    
    private func fetchTickets() {
        Task {
            isLoading = true
            do {
                let response = try await ticketUseCase.getAllTickets()
                tickets = response.tickets
            } catch {
                print("Failed to load tickets: \(error)")
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
            isLoading = false
        }
    }
    
    // 핍압에 띄울 티켓 조회
    func fetchDdayTickets() {
        Task {
            do {
                ddayTickets = try await ticketUseCase.getTicketsComplete()
            } catch {
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
        }
    }
    
    func updateDdayTicketEmotion(_ emotions: [Emotion]) {
        Task {
            do {
                _ = try await ticketUseCase.updateTicketEmotions(
                    ticketId: selectedDdayTicketId,
                    emotions: emotions
                )
                
                // Update local ddayTickets state so UI reflects new emotions immediately
                if let index = ddayTickets.firstIndex(where: { $0.id == selectedDdayTicketId }) {
                    var updatedSummary = ddayTickets[index]
                    updatedSummary.emotions = emotions
                    ddayTickets[index] = updatedSummary
                }
                
                isEmotionSheetPresent = false
            } catch {
                ToastManager.shared.show(.errorStringWithTask("감정 등록"))
            }
        }
    }
    
    // Navigate to ticket book tab
    func navigateToTicketBook() {
        NotificationCenter.default.post(
            name: NotificationEvent.didTapTicketBook.name,
            object: nil,
            userInfo: [NotificationEvent.didTapTicketBook.userInfo: TabItem.ticketBook.rawValue]
        )
    }

    // Check if tutorial should be shown
    func checkTutorialVisibility() {
        Task {
            do {
                let visibility = try await onboardingUseCase.getVisibility(type: .main)
                if visibility.isVisible {
                    PopupManager.shared.show(.custom(
                    HomeTutorialOverlay(
                        onDismiss: { [weak self] in
                            self?.completeTutorial()
                        }
                    )
                    ))
                }
            } catch {
                print("Failed to check tutorial visibility: \(error)")
            }
        }
    }

    // Update tutorial visibility (mark as seen)
    func completeTutorial() {
        Task {
            do {
                try await onboardingUseCase.updateVisibility(type: .main)
            } catch {
                print("Failed to update tutorial visibility: \(error)")
            }
        }
    }
}
