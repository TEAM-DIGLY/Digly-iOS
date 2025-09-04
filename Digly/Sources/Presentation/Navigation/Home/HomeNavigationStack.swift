import SwiftUI

@MainActor
final class HomeRouter: BaseRouter {
    typealias RouteType = HomeRoute
    @Published var path = NavigationPath()
}

struct HomeNavigationStack: View {
    @EnvironmentObject private var router: HomeRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom){
                HomeView()
                BottomTabView(selectedTab: $selectedTab)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                    }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .alarmList: AlarmListView()
        case .myPage: MyPageView()
        case .addTicket: AddTicketView()
        case .ticketAutoInput: TicketAutoInputView()
        case .createTicketForm: CreateTicketFormView()
        }
    }
} 

#Preview {
    HomeNavigationStack(selectedTab: .constant(0))
        .environmentObject(HomeRouter())
}
