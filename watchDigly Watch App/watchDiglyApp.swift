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
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    var wcSession: WCSession?
    
    func applicationDidFinishLaunching() {
        setupWCSession()
        scheduleBackgroundRefresh()
    }
    
    func setupWCSession() {
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
    }
    
    func scheduleBackgroundRefresh() {
        let nextUpdateDate = Date().addingTimeInterval(15 * 60) // 15분 후
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextUpdateDate, userInfo: nil) { (error) in
            if let error = error {
                print("Failed to schedule background refresh: \(error.localizedDescription)")
            }
        }
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                handleBackgroundRefresh(task: backgroundTask)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompletedWithSnapshot(false)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                handleWatchConnectivity(task: connectivityTask)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                handleURLSession(task: urlSessionTask)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func handleBackgroundRefresh(task: WKApplicationRefreshBackgroundTask) {
        // 백그라운드에서 데이터 동기화 또는 업데이트 수행
        sendDataToiOSApp()
        
        // 다음 백그라운드 업데이트 스케줄링
        scheduleBackgroundRefresh()
        
        task.setTaskCompletedWithSnapshot(false)
    }
    
    func handleWatchConnectivity(task: WKWatchConnectivityRefreshBackgroundTask) {
        // Watch Connectivity 관련 작업 처리
        sendDataToiOSApp()
        task.setTaskCompletedWithSnapshot(false)
    }
    
    func handleURLSession(task: WKURLSessionRefreshBackgroundTask) {
        // URL 세션 관련 작업 처리
        URLSession.shared.getAllTasks { (tasks) in
            // 필요한 네트워크 작업 수행
            task.setTaskCompletedWithSnapshot(false)
        }
    }
    
    func sendDataToiOSApp() {
        guard let wcSession = wcSession, wcSession.isReachable else {
            print("WCSession is not reachable")
            return
        }
        
        let message = ["lastUpdated": Date()]
        wcSession.sendMessage(message, replyHandler: nil) { (error) in
            print("Failed to send message: \(error.localizedDescription)")
        }
    }
    
    // WCSessionDelegate 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully")
        }
    }
}

#Preview {
    ContentView()
}
