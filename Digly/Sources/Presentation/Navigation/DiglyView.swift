import SwiftUI

struct DiglyView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    @StateObject private var toastManager = ToastManager.shared
    
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var ticketBookRouter = TicketBookRouter()
    @StateObject private var diggingNoteRouter = DiggingNoteRouter()
    
    @StateObject private var authRouter = AuthRouter()
    
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            if authManager.isLoggedIn {
                switch(selectedTab) {
                case 0:
                    HomeNavigationStack(selectedTab: $selectedTab)
                        .environmentObject(homeRouter)
                case 1:
                    DiggingNoteNavigationStack(selectedTab: $selectedTab)
                        .environmentObject(diggingNoteRouter)
                default:
                    TicketBookNavigationStack(selectedTab: $selectedTab)
                        .environmentObject(ticketBookRouter)
                }
            } else {
                AuthNavigationStack()
                    .environmentObject(authRouter)
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
            }
        }
    }
}
