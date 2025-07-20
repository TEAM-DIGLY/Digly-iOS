import SwiftUI

@MainActor
final class TicketBookRouter: BaseRouter {
    typealias RouteType = TicketBookRoute
    @Published var path = NavigationPath()
}

struct TicketBookNavigationStack: View {
    @EnvironmentObject private var router: TicketBookRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TicketBookView()
                .navigationDestination(for: TicketBookRoute.self) { route in
                    destinationView(for: route)
                        .swipeBackDisabled(route.disableSwipeBack)
                        .onAppear {
//                            print("📊 Main Analytics: \(route.analyticsName)")
//                            print("🔒 SwipeBack enabled: \(route.disableSwipeBack)")
//                            print("📋 TabBar hidden: \(route.hidesTabBar)")
                        }
                }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: TicketBookRoute) -> some View {
        switch route {
        case .ticketBook: 
            TicketBookView()
        case .ticketDetail(let ticketId): 
            TicketDetailView(ticketId: ticketId)
        }
    }
} 

#Preview {
    TicketBookNavigationStack()
        .environmentObject(TicketBookRouter())
}
