import Foundation
import WatchConnectivity
import Alamofire

class HeartRateViewModel: NSObject, ObservableObject {
    @Published var currentHeartRate: Double = 0
    @Published var message: String = ""
    @Published var connectionStatus: String = "Disconnected"
    @Published var dataType: String = ""
    @Published var lastUpdated: String = ""
    @Published var isMonitoring: Bool = true
    
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
    
    func toggleHeartRateMonitoring() {
        isMonitoring.toggle()
        
        if isMonitoring {
            startHeartRateMonitoring()
        } else {
            stopHeartRateMonitoring()
        }
    }
    
    func startHeartRateMonitoring() {
        sendMessageToWatch(["command": "startMonitoring"])
        message = "Starting heart rate monitoring..."
    }
    
    private func stopHeartRateMonitoring() {
        sendMessageToWatch(["command": "stopMonitoring"])
        message = "Stopping heart rate monitoring..."
        currentHeartRate = 0
    }
    
    private func sendMessageToWatch(_ message: [String: Any]) {
        guard let session = wcSession, session.isReachable else {
            self.message = "Watch is not reachable"
            return
        }
        
        session.sendMessage(message, replyHandler: nil) { error in
            DispatchQueue.main.async {
                self.message = "Failed to send message to watch: \(error.localizedDescription)"
            }
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
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.connectionStatus = "Session Inactive"
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let heartRate = message["heartRate"] as? Double {
                self.currentHeartRate = heartRate
            }
        }
    }
}
