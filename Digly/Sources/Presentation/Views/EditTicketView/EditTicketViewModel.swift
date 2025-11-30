import SwiftUI
import Combine

@MainActor
final class EditTicketViewModel: ObservableObject {
    @Published var formData = CreateTicketFormData()
    @Published var isLoading: Bool = false

    private let ticketUseCase: TicketUseCase
    private let originalTicket: Ticket

    var onTicketUpdated: ((Ticket) -> Void)?

    init(
        ticket: Ticket,
        ticketUseCase: TicketUseCase = TicketUseCase(),
        onTicketUpdated: ((Ticket) -> Void)? = nil
    ) {
        self.originalTicket = ticket
        self.ticketUseCase = ticketUseCase
        self.onTicketUpdated = onTicketUpdated

        // Initialize form data with existing ticket info
        formData.showName = ticket.name
        formData.place = ticket.place
        formData.date = ticket.time
        formData.time = ticket.time
        formData.count = ticket.count
        formData.seatNumber = ticket.seatNumber ?? ""
        formData.price = ticket.price ?? -1
    }

    var isUpdateButtonEnabled: Bool {
        return formData.isBasicInfoComplete
    }

    func updateTicket() {
        Task {
            do {
                isLoading = true
                guard let performanceDateTime = formData.combinedPerformanceDateTime else {
                    isLoading = false
                    ToastManager.shared.show(.errorWithMessage("관람 일시가 올바르지 않습니다."))
                    return
                }

                let updatedTicket = try await ticketUseCase.updateTicket(
                    ticketId: originalTicket.id,
                    name: formData.showName,
                    time: performanceDateTime,
                    place: formData.place,
                    count: formData.count,
                    seatNumber: formData.seatNumber.isEmpty ? nil : formData.seatNumber,
                    price: formData.price == -1 ? nil : formData.price,
                    emotions: originalTicket.emotions.map { $0.rawValue }
                )

                isLoading = false
                onTicketUpdated?(updatedTicket)
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 수정"))
                print("티켓 수정 실패: \(error)")
            }
        }
    }

    func updateSeatNumber(_ seat: String) {
        formData.setSeatNumber(seat)
    }

    func updateTicketPrice(_ price: Int) {
        formData.setTicketPrice(price)
    }
}
