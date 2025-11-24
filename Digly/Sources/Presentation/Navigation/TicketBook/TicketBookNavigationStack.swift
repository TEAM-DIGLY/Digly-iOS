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
                    .onAppear {
                        //                            print("📊 Main Analytics: \(route.analyticsName)")
                        //                            print("🔒 SwipeBack enabled: \(route.disableSwipeBack)")
                        //                            print("📋 TabBar hidden: \(route.hidesTabBar)")
                    }
            }
            .navigationDestination(for: TicketFlowRoute.self) { route in
                ticketFlowDestinationView(for: route)
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
            TicketDetailView(ticketId: ticketId)
        case .ticketFlow:
            TicketFlowNavigationStack(onFlowCompleted: {
                router.pop() // Return to previous screen when ticket flow completes
            })
        }
    }
    
    @ViewBuilder
    private func ticketFlowDestinationView(for route: TicketFlowRoute) -> some View {
        switch route {
        case .addTicket:
            StartAddTicketManualView(
                onNavigateToAutoInput: {
                    router.path.append(TicketFlowRoute.ticketAutoInput)
                },
                onNavigateToCreateTicket: {
                    router.path.append(TicketFlowRoute.createTicketForm)
                }
            )
        case .ticketAutoInput:
            AddTicketAutoView()
        case .createTicketForm:
            AddTicketManualView(
                onNavigateToEndTicket: { ticketData in
                    router.path.append(TicketFlowRoute.endCreateTicket(ticketData: ticketData))
                }
            )
        case .endCreateTicket(let ticketData):
            EndAddTicketManualView(
                ticketData: ticketData,
                onAddFeelingTapped: {
                    router.path.append(TicketFlowRoute.addFeelingView)
                },
                onEditTicketTapped: {
                    router.path.append(TicketFlowRoute.editTicketView)
                },
                onCompleteTapped: {
                    router.pop() // Go back to TicketBookView
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
    TicketBookNavigationStack(selectedTab: .constant(2))
        .environmentObject(TicketBookRouter())
}
