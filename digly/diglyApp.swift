//
//  diglyApp.swift
//  digly
//
//  Created by 김 형석 on 10/9/24.
//

import SwiftUI
import GoogleSignIn

@main
struct diglyApp: App {
    @StateObject private var appState = AppState.shared
    
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
        if appState.isLoggedIn || appState.isGuestMode {
            MainTabView()
        } else {
            OnboardingView()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState.shared)
}
