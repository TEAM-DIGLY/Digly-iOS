import SwiftUI

@MainActor
final class DiggingNoteRouter: BaseRouter {
    typealias RouteType = DiggingNoteRoute
    @Published var path = NavigationPath()
}

struct DiggingNoteNavigationStack: View {
    @EnvironmentObject private var router: DiggingNoteRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            DiggingNoteView()
                .navigationDestination(for: DiggingNoteRoute.self) { route in
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
    private func destinationView(for route: DiggingNoteRoute) -> some View {
        switch route {
        case .diggingNote: DiggingNoteView()
        case .writeDiggingNote: WriteDiggingNoteView()
        }
    }
} 

#Preview {
    DiggingNoteNavigationStack(selectedTab: .constant(1))
        .environmentObject(DiggingNoteRouter())
}
