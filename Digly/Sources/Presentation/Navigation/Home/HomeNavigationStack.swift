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
                DGBottomTab(selectedTab: $selectedTab)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                    }
            }
            .navigationDestination(for: TicketFlowRoute.self) { route in
                ticketFlowDestinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .alarmList: AlarmListView()
        case .myPage: MyPageView()
        case .agreementDetail(let type):
            AgreementDetailView(agreementType: type)
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
            AddTicketView(
                onNavigateToAutoInput: {
                    router.path.append(TicketFlowRoute.ticketAutoInput)
                },
                onNavigateToCreateTicket: {
                    router.path.append(TicketFlowRoute.createTicketForm)
                }
            )
        case .ticketAutoInput:
            TicketAutoInputView()
        case .createTicketForm:
            CreateTicketFormView(
                onNavigateToEndTicket: { ticketData in
                    router.path.append(TicketFlowRoute.endCreateTicket(ticketData: ticketData))
                }
            )
        case .endCreateTicket(let ticketData):
            EndCreateTicketView(
                ticketData: ticketData,
                onAddFeelingTapped: {
                    router.path.append(TicketFlowRoute.addFeelingView)
                },
                onEditTicketTapped: {
                    router.path.append(TicketFlowRoute.editTicketView)
                },
                onCompleteTapped: {
                    router.pop() // Go back to HomeView
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
    HomeNavigationStack(selectedTab: .constant(0))
        .environmentObject(HomeRouter())
}
