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
                        completeFlow: { router.reset() }
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
            AddTicketAutoView(onNavigateToConfirm: { ticket in
                handlers.push(.ticketAutoConfirm(ticketForm: ticket))
            })
            
        case .ticketAutoConfirm(let ticketForm):
            AddTicketAutoConfirmView(
                ticketFormData: ticketForm,
                onNavigatedToEnd: { ticket in
                handlers.push(.endCreateTicket(ticket: ticket))
            })
        case .createTicketForm:
            AddTicketManualView(
                onNavigateToEndTicket: { ticket in
                    handlers.push(.endCreateTicket(ticket: ticket))
                }
            )
        case .endCreateTicket(let ticketData): 
            EndAddTicketManualView(
                ticket: ticketData,
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
