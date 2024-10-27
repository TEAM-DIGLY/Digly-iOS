import Foundation
import WatchConnectivity
import Alamofire
import Combine

class HeartRateViewModel: NSObject, ObservableObject {
    let manager = WatchConnectivityManager.shared
    
    @Published var currentHeartRate: Double = 0
    @Published var message: String = ""
    
    @Published var debugMessage: [String] = ["message1"]
    @Published var isMonitoring: Bool = true
    
    private var timer: Timer?
    
    override init() {
        super.init()
        manager.startMonitoringConnectionStatus()
        setupNotificationObservers()
        setupMessageReceiver()
    }
    
    func toggleHeartRateMonitoring() {
        isMonitoring.toggle()
        if isMonitoring {
            startHeartRateMonitoring()
        } else {
            sendMessageToWatch(["command": "stopMonitoring"])
        }
    }
    
    func startHeartRateMonitoring (){
        sendMessageToWatch(["command": "startMonitoring"])
    }
    
    private func setupMessageReceiver() {
        manager.iOSMessageReceiver = { [weak self] message in
            if let heartRate = message["heartRate"] as? Double {
                DispatchQueue.main.async {
                    self?.currentHeartRate = heartRate
                }
            }
            
            if let debugMessage = message["debug"] as? String {
                DispatchQueue.main.async {
                    self?.debugMessage.append(debugMessage)
                }
            }
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .watchUnreachable, object: nil, queue: .main) { _ in
            self.message = "Watch became unreachable"
        }
        
        NotificationCenter.default.addObserver(forName: .watchReachabilityChanged, object: nil, queue: .main) { _ in
            self.message = "Watch reachability changed"
        }
    }
    
    private func sendMessageToWatch(_ message: [String: Any]) {
        manager.sendMessage(message) { error in
            DispatchQueue.main.async {
                self.message = "Error sending message: \(error.localizedDescription)"
            }
        }
    }
}
