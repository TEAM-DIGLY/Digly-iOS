import SwiftUI

struct TicketFlowNavigationStack: View {
    let onFlowCompleted: () -> Void
    @StateObject private var router: TicketFlowRouter
    
    init(onFlowCompleted: @escaping () -> Void) {
        self.onFlowCompleted = onFlowCompleted
        self._router = StateObject(wrappedValue: TicketFlowRouter(onFlowCompleted: onFlowCompleted))
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            StartAddTicketManualView(
                onNavigateToAutoInput: { router.push(to: .ticketAutoInput) },
                onNavigateToCreateTicket: { router.push(to: .createTicketForm) }
            )
            .environmentObject(router)
            .navigationDestination(for: TicketFlowRoute.self) { route in
                TicketFlowNavigationStack.destinationView(
                    for: route,
                    handlers: .init(
                        push: { router.path.append($0) },
                        pop: { router.pop() },
                        completeFlow: { router.completeFlow() }
                    )
                )
                .environmentObject(router)
            }
        }
    }
    
    @ViewBuilder
    static func destinationView(
        for route: TicketFlowRoute,
        handlers: TicketFlowNavigationHandlers
    ) -> some View {
        switch route {
        case .addTicket: 
            StartAddTicketManualView(
                onNavigateToAutoInput: {
                    handlers.push(.ticketAutoInput)
                },
                onNavigateToCreateTicket: {
                    handlers.push(.createTicketForm)
                }
            )
        case .ticketAutoInput:
            AddTicketAutoView()
        case .createTicketForm: 
            AddTicketManualView(
                onNavigateToEndTicket: { ticketData in
                    handlers.push(.endCreateTicket(ticketData: ticketData))
                }
            )
        case .endCreateTicket(let ticketData): 
            EndAddTicketManualView(
                ticketData: ticketData,
                onAddFeelingTapped: {
                },
                onEditTicketTapped: {
                },
                onCompleteTapped: {
                    handlers.completeFlow()
                }
            )
        }
    }
}

struct TicketFlowNavigationHandlers {
    let push: (TicketFlowRoute) -> Void
    let pop: () -> Void
    let completeFlow: () -> Void
}

#Preview {
    TicketFlowNavigationStack(onFlowCompleted: {})
}
