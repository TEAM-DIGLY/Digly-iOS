import SwiftUI

struct TicketFlowNavigationStack: View {
    let onFlowCompleted: () -> Void
    @StateObject private var router: TicketFlowRouter
    
    init(onFlowCompleted: @escaping () -> Void) {
        self.onFlowCompleted = onFlowCompleted
        self._router = StateObject(wrappedValue: TicketFlowRouter(onFlowCompleted: onFlowCompleted))
    }
    
    var body: some View {
        AddTicketView()
            .environmentObject(router)
    }
    
    @ViewBuilder
    private func destinationView(for route: TicketFlowRoute) -> some View {
        switch route {
        case .addTicket: 
            AddTicketView()
        case .ticketAutoInput:
            TicketAutoInputView()
        case .createTicketForm: 
            CreateTicketFormView()
        case .endCreateTicket(let ticketData): 
            EndCreateTicketView(
                ticketData: ticketData,
                onAddFeelingTapped: {
                    router.push(to: .addFeelingView)
                },
                onEditTicketTapped: {
                    router.push(to: .editTicketView)
                },
                onCompleteTapped: {
                    router.completeFlow()
                }
            )
        case .addFeelingView: 
            PlaceholderView(title: "AddFeelingView", subtitle: "감정 입력 화면 (미구현)")
        case .editTicketView: 
            PlaceholderView(title: "EditTicketView", subtitle: "티켓 정보 수정 화면 (미구현)")
        }
    }
}

#Preview {
    TicketFlowNavigationStack(onFlowCompleted: {})
}