//
//  watchDiglyApp.swift
//  watchDigly Watch App
//
//  Created by 김 형석 on 10/9/24.
//

import SwiftUI
import Foundation
import WatchKit
import WatchConnectivity

@main
struct watchDigly_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(WatchAppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class WatchAppDelegate: NSObject, WKApplicationDelegate, WKExtendedRuntimeSessionDelegate {
    var extendedSession: WKExtendedRuntimeSession?
    
    func applicationDidFinishLaunching() {
        // 앱 시작시 설정
    }
    
    // 백그라운드 진입시 Extended Runtime Session 시작
    func applicationDidEnterBackground() {
        startExtendedRuntimeSession()
    }
    
    private func startExtendedRuntimeSession() {
        // 이전 세션이 있다면 종료
        extendedSession?.invalidate()
        
        // 새로운 세션 시작
        let session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
        extendedSession = session
    }
    
    // MARK: - WKExtendedRuntimeSessionDelegate
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // 세션이 종료되면 일정 시간 후 재시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startExtendedRuntimeSession()
        }
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session started")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // 세션 만료 예정 - 중요 작업 완료
        HeartRateSyncManager.shared.forceSyncPendingData()
    }
}
