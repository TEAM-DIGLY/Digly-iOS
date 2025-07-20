import SwiftUI

@MainActor
final class HomeRouter: BaseRouter {
    typealias RouteType = HomeRoute
    @Published var path = NavigationPath()
}

struct HomeNavigationStack: View {
    @EnvironmentObject private var router: HomeRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: HomeRoute.self) { route in
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
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .alarmList: AlarmListView()
        case .myPage: MyPageView()
        }
    }
} 

#Preview {
    HomeNavigationStack()
        .environmentObject(HomeRouter())
}
 
