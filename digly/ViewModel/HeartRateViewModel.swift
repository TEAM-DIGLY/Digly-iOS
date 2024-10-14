//
//  HeartRateViewModel.swift
//  digly
//
//  Created by 김 형석 on 10/9/24.
//

import Foundation
import WatchConnectivity

class HeartRateViewModel: NSObject, ObservableObject {
    @Published var currentHeartRate: Double = 0
    @Published var message: String = ""
    @Published var connectionStatus: String = "Disconnected"
    @Published var dataType: String = ""
    @Published var lastUpdated: String = ""
    //TODO: private var로 변경하기(지금은 디버깅 위해 ui 띄우려고 임시 @Published 속성 부여)
    @Published var maxHeartRate: Double = 0
    
    private var timer: Timer?
    private var wcSession: WCSession?
    
    override init() {
        super.init()
        setupWatchConnectivity()
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
    }
    
    func updateConnectionStatus() {
        guard let session = wcSession else {
            connectionStatus = "Watch Connectivity Not Supported"
            return
        }
        
        if session.isPaired {
            if session.isWatchAppInstalled {
                connectionStatus = session.isReachable ? "Connected" : "Watch App Installed but Not Reachable"
                
            } else {
                connectionStatus = "Watch Paired but App Not Installed"
            }
        } else {
            connectionStatus = "Watch Not Paired"
        }
    }
    
    private func startMaxHeartRateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            //TODO: self?.sendMaxHeartRateToServer()
            self?.maxHeartRate = 0
            print("sendMaxHeartRateToServer")
        }
    }
}

extension HeartRateViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("WCSession activation failed with error: \(error.localizedDescription)")
                self.connectionStatus = "Activation Failed"
            } else {
                print("WCSession activated with state: \(activationState.rawValue)")
                self.updateConnectionStatus()
                self.startMaxHeartRateTimer()
            }
        }
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.connectionStatus = "Session Inactive"
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let heartRate = message["heartRate"] as? Double {
                self.currentHeartRate = heartRate
                self.maxHeartRate = max(self.maxHeartRate, heartRate)
            }
        }
    }
}
