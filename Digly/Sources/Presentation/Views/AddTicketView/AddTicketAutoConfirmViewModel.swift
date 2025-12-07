import SwiftUI
import Combine

@MainActor
final class AddTicketAutoConfirmViewModel: ObservableObject {
    @Published var formData = CreateTicketFormData()
    @Published var isLoading: Bool = false
    @Published var dateTimeStep: DateTimeStep = .date
    
    private let ticketUseCase: TicketUseCase
    
    var onTicketUpdated: ((Ticket) -> Void)?
    
    init(
        ticketFormData: CreateTicketFormData,
        ticketUseCase: TicketUseCase = TicketUseCase(),
        onTicketUpdated: ((Ticket) -> Void)? = nil
    ) {
        self.ticketUseCase = ticketUseCase
        self.formData = ticketFormData
    }
    
    var isUpdateButtonEnabled: Bool {
        return formData.isBasicInfoComplete
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
    
    func submitTicket(onSuccess: @escaping (Ticket) -> Void) {
        Task {
            do {
                isLoading = true
                guard let performanceDateTime = formData.combinedPerformanceDateTime else {
                    isLoading = false
                    ToastManager.shared.show(.errorWithMessage("관람 일시가 올바르지 않습니다."))
                    return
                }
                
                let ticket = try await ticketUseCase.createTicket(
                    name: formData.showName,
                    time: performanceDateTime,
                    place: formData.place,
                    count: formData.count,
                    seatNumber: formData.seatNumber,
                    price: Int(formData.price) ?? -1,
                    emotions: [] // TODO: EmotionColor 선택 기능 추가 시 수정
                )
                isLoading = false
                ToastManager.shared.show(.success("티켓이 생성되었습니다."))
                
                onSuccess(ticket)
            } catch {
                isLoading = false
                ToastManager.shared.show(.error(error))
                print("티켓 생성 실패: \(error)")
            }
        }
    }

}
