//
//  diglyApp.swift
//  digly
//
//  Created by 김 형석 on 10/9/24.
//

import SwiftUI
import GoogleSignIn

class AppState: ObservableObject {
    static let shared = AppState() // 전역적으로 접근 가능한 인스턴스 생성. 이는 싱글톤으로 구현되어있는 APIManager에서 appState를 직접 접근하게 하기 위해서임.
    @Published var isLoggedIn: Bool = true // Published 래퍼를 통해 상태 변화를 SwiftUI 뷰에 자동반영
    @Published var isGuestMode: Bool = false
    
    private init() {}
}

@main
struct diglyApp: App {
    @StateObject private var appState = AppState.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
//                .onOpenURL { url in
//                    GIDSignIn.sharedInstance.handle(url)
//                }
//                .onAppear {
//                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                        if error != nil || user == nil {
//                            appState.isLoggedIn = false
//                        } else {
//                            appState.isLoggedIn = true
//                        }
//                    }
//                }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
//        if appState.isLoggedIn || appState.isGuestMode {
            MainTabView()
//        } else {
//            OnboardingView()
//                .ignoresSafeArea()
//        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}


#Preview {
    ContentView()
}
