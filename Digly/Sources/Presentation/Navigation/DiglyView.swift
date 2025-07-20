import SwiftUI

struct DiglyView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    @StateObject private var router = HomeRouter()
    @StateObject private var authRouter = AuthRouter()
    
    var body: some View {
        VStack {
            if authManager.isLoggedIn {
                HomeNavigationStack()
                DiggingNoteNavigationStack()
                TicketBookNavigationStack()
            } else {
                AuthNavigationStack()
            }
        }
        .environmentObject(router)
        .presentPopup(
            isPresented: $popupManager.popupPresented,
            data: popupManager.currentPopupData
        )
        .onChange(of: authManager.isLoggedIn) { _, isLoggedIn in
            if !isLoggedIn {
                router.reset()
                authRouter.reset()
            }
        }
    }
}

#Preview("로그인 상태") {
    DiglyView()
        .onAppear {
            AuthManager.shared.login()
        }
}

#Preview("로그아웃 상태") {
    DiglyView()
        .onAppear {
            AuthManager.shared.logout()
        }
}

#Preview("업데이트 필수 팝업") {
    DiglyView()
        .onAppear {
            PopupManager.shared.show(type: .updateMandatory) {
                print("업데이트 필수 액션")
            }
        }
}

#Preview("업데이트 선택 팝업") {
    DiglyView()
        .onAppear {
            PopupManager.shared.show(type: .updateOptional) {
                print("업데이트 선택 액션")
            }
        }
}
