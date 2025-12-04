import SwiftUI

@MainActor
final class TicketBookRouter: BaseRouter {
    typealias RouteType = TicketBookRoute
    @Published var path = NavigationPath()
}

struct TicketBookNavigationStack: View {
    @EnvironmentObject private var router: TicketBookRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom){
                TicketBookView()
                DGBottomTab(selectedTab: $selectedTab)
            }
            .navigationDestination(for: TicketBookRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
            }
            .navigationDestination(for: TicketFlowRoute.self) { route in
                TicketFlowNavigationStack.destinationView(
                    for: route,
                    handlers: .init(
                        push: { router.path.append($0) },
                        pop: { router.pop() },
                        completeFlow: { router.pop() }
                    )
                )
                    .swipeBackDisabled(route.disableSwipeBack)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: TicketBookRoute) -> some View {
        switch route {
        case .ticketBook:
            TicketBookView()
        case .ticketDetail(let ticketId):
            TicketDetailView(
                ticketId: ticketId,
                onNavigateToEdit: { ticket in router.push(to: .editTicket(ticket))},
                onNavigateReset: { router.reset() },
                onNavigateToNoteDetail: { noteId in
                    router.push(to: .noteDetail(ticketId: ticketId, noteId: noteId))
                }
            )
        case .ticketFlow:
            TicketFlowNavigationStack(onFlowCompleted: {
                router.pop() // Return to previous screen when ticket flow completes
            })
        case .editTicket(let ticket):
            EditTicketView(ticket: ticket)
        case .noteDetail(let ticketId, let noteId):
            DiggingNoteDetailView(
                ticketId: ticketId,
                noteId: noteId
            )
        }
    }
}

#Preview {
    TicketBookNavigationStack(selectedTab: .constant(2))
        .environmentObject(TicketBookRouter())
}
