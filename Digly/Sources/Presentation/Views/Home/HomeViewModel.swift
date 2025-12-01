import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var isLoading: Bool = false
    @Published var focusedTicketIndex: Int = 0
    @Published var ticketNotes: [Note] = []
    @Published var ddayTickets: [TicketComplete] = []
    
    // popup에서 사용자에게 보여지는 티켓에 대한 데이터입니다.
    @Published var popupTicket: TicketComplete? = nil
    @Published var selectedEmotionsPerTicket: [Int: [Emotion]] = [:]

    // Popup states
    @Published var isEmotionSheetPresent: Bool = false

    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase

    // Popup callbacks
    var onShowDdayAlert: ((Ticket) -> Void)?
    var onShowEmotionCompleted: ((Ticket, [Emotion]) -> Void)?

    var focusedTicket: Ticket? {
        tickets.isEmpty ? nil : tickets[safe: focusedTicketIndex]
    }
    
    init(ticketUseCase: TicketUseCase = TicketUseCase(),
         noteUseCase: NoteUseCase = NoteUseCase()) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        
        fetchTickets()
        
    }
    
    private func fetchTickets() {
        Task {
            isLoading = true
            do {
                let response = try await ticketUseCase.getAllTickets()
                tickets = response.tickets
                
                if !tickets.isEmpty {
                    focusedTicketIndex = 0
//                    await loadNotesForFocusedTicket()
                }
            } catch {
                print("Failed to load tickets: \(error)")
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
            isLoading = false
        }
    }
    
    func updateFocusedTicket(index: Int) {
        guard index != focusedTicketIndex && index >= 0 && index < tickets.count else { return }
        focusedTicketIndex = index
        
        Task {
//            await loadNotesForFocusedTicket()
        }
    }
    
    // Computed property to get note count for focused ticket
    var noteCount: Int {
        ticketNotes.count
    }

    var emotionsForPopupTicket: [Emotion] {
        guard let popupTicket else { return [] }
        return selectedEmotionsPerTicket[popupTicket.id] ?? []
    }
    
    // Calculate days remaining until performance
    func daysUntilPerformance(for ticket: Ticket) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let performanceDay = calendar.startOfDay(for: ticket.time)
        
        let components = calendar.dateComponents([.day], from: today, to: performanceDay)
        return components.day ?? 0
    }
    
    // Check if performance is today
    func isPerformanceToday(for ticket: Ticket) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(ticket.time, inSameDayAs: Date())
    }

    // 핍압에 띄울 티켓 조회
    func checkForDdayTickets() {
        Task {
            do {
                let completedTickets = try await ticketUseCase.getTicketsComplete()
                guard !completedTickets.isEmpty else { return }

                ddayTickets = completedTickets

                PopupManager.shared.show(.custom(
                    DdayAlertPopup(
                        tickets: completedTickets,
                        onEmotionButtonTap: { [weak self] ticket in
                            guard let self else { return }
                            popupTicket = ticket
                            PopupManager.shared.dismissPopup()
                            isEmotionSheetPresent = true
                        },
                        onDismiss: {
                            PopupManager.shared.dismissPopup()
                        }
                    )
                ))
            } catch {
                ToastManager.shared.show(.errorStringWithTask("티켓 로딩"))
            }
        }
    }
    
    func updateTicketEmotions(_ emotions: [Emotion], onSuccess: @escaping (Ticket) -> Void) {
        guard let popupTicket else { return }
        Task {
            do {
                let response = try await ticketUseCase.updateTicketEmotions(
                    ticketId: popupTicket.id,
                    emotions: emotions
                )

                selectedEmotionsPerTicket[popupTicket.id] = emotions
                self.popupTicket = nil
                onSuccess(response)
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
}
