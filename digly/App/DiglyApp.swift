import SwiftUI
import GoogleSignIn

@main
struct diglyApp: App {
    
    var body: some Scene {
        WindowGroup {
            DiglyView()
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
