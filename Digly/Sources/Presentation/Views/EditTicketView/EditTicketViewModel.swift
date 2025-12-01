import SwiftUI
import Combine

@MainActor
final class EditTicketViewModel: ObservableObject {
    @Published var formData = CreateTicketFormData()
    @Published var isLoading: Bool = false
    @Published var dateTimeStep: DateTimeStep = .date
    
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
        
        // Initialize form data with existing ticket info
        formData.showName = ticket.name
        formData.place = ticket.place
        formData.date = ticket.time
        formData.time = ticket.time
        formData.count = ticket.count
        formData.seatNumber = ticket.seatNumber ?? ""
        formData.price = String(describing: ticket.price)
    }
    
    var isUpdateButtonEnabled: Bool {
        return formData.isBasicInfoComplete
    }
    
    func updateTicket(onSuccess: () -> Void) async {
        isLoading = true
        do {
            guard let performanceDateTime = formData.combinedPerformanceDateTime else {
                isLoading = false
                ToastManager.shared.show(.errorWithMessage("관람 일시가 올바르지 않습니다."))
                return
            }
            
            let _ = try await ticketUseCase.updateTicket(
                ticketId: originalTicket.id,
                name: formData.showName,
                time: performanceDateTime,
                place: formData.place,
                count: formData.count,
                seatNumber: formData.seatNumber.isEmpty ? nil : formData.seatNumber,
                price: Int(formData.price) ?? nil ,
                emotions: originalTicket.emotions.map { $0.rawValue }
            )
            
            isLoading = false
            
            ToastManager.shared.show(.success("티켓이 수정되었어요"))
            onSuccess()
            
        } catch {
            isLoading = false
            ToastManager.shared.show(.errorStringWithTask("티켓 수정"))
        }
    }
    
    func setDateTimeFieldBinding(for step: DateTimeStep) -> Binding<Date> {
        switch step {
        case .date:
            return Binding(
                get: { self.formData.date ?? Date() },
                set: { newValue in
                    self.formData.updateDate(from: newValue)
                }
            )
        case .time:
            return Binding(
                get: {
                    if let time = self.formData.time { return time }
                    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                    components.hour = 15
                    components.minute = 0
                    return Calendar.current.date(from: components) ?? Date()
                },
                set: { newValue in
                    self.formData.updateTime(from: newValue)
                }
            )
        }
    }

}
