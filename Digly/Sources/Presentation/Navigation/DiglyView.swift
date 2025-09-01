import SwiftUI

struct DiglyView: View {
    @StateObject private var viewModel = DiglyViewModel()
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    @StateObject private var toastManager = ToastManager.shared
    
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var ticketBookRouter = TicketBookRouter()
    @StateObject private var diggingNoteRouter = DiggingNoteRouter()
    
    @StateObject private var authRouter = AuthRouter()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            VStack(spacing: 0) {
                if viewModel.isInitializing {
                    // Launch Screen
                    LaunchScreenView()
                } else if authManager.isLoggedIn {
                    switch(viewModel.selectedTab) {
                    case 0:
                        HomeNavigationStack(selectedTab: $viewModel.selectedTab)
                            .environmentObject(homeRouter)
                    case 1:
                        DiggingNoteNavigationStack(selectedTab: $viewModel.selectedTab)
                            .environmentObject(diggingNoteRouter)
                    default:
                        TicketBookNavigationStack(selectedTab: $viewModel.selectedTab)
                            .environmentObject(ticketBookRouter)
                    }
                } else {
                    AuthNavigationStack()
                        .environmentObject(authRouter)
                }
            }
        }
        .presentPopup(
            isPresented: $popupManager.popupPresented,
            data: popupManager.currentPopupData
        )
        .presentToast(
            isPresented: $toastManager.toastPresented,
            data: toastManager.currentToastType
        )
        .onChange(of: authManager.isLoggedIn) { _, isLoggedIn in
            if !isLoggedIn {
                homeRouter.reset()
                ticketBookRouter.reset()
                diggingNoteRouter.reset()
                
                authRouter.reset()
                viewModel.selectedTab = 0
            }
        }
        .task {
            await viewModel.initialize()
        }
    }
}
