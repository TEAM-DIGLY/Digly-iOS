import SwiftUI

@main
struct diglyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            DiglyView()
                .onOpenURL { url in
                    // URL 스킴 처리는 AppDelegate에서 담당
                    _ = appDelegate.application(UIApplication.shared, open: url, options: [:])
                }
        }
    }
}
