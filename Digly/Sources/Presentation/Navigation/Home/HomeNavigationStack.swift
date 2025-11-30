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
        case .inquiry: InquiryView()
        case .agreementDetail(let type):
            AgreementDetailView(agreementType: type)
        case .profileSetting:
            ProfileSettingView()
        case .ticketFlow:
            TicketFlowNavigationStack(onFlowCompleted: {
                router.pop() // Return to previous screen when ticket flow completes
            })
            
        case .ticketDetail(let ticketId):
            TicketDetailView(
                ticketId: ticketId,
                onNavigateToEdit: { ticket in router.push(to: .editTicket(ticket))},
                onNavigateReset: { router.reset() }
            )
        case .editTicket(let ticket):
            EditTicketView(ticket: ticket)
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
                    // TODO: 연결 동작 정의
                },
                onEditTicketTapped: {
                    // TODO: 연결 동작 정의
                },
                onCompleteTapped: {
                    router.pop()
                }
            )
        }
    }
} 

#Preview {
    HomeNavigationStack(selectedTab: .constant(0))
        .environmentObject(HomeRouter())
}
