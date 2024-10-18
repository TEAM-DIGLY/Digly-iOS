import Foundation
import WatchConnectivity
import Alamofire
import Combine

class HeartRateViewModel: NSObject, ObservableObject {
    let manager = WatchConnectivityManager.shared
    
    @Published var currentHeartRate: Double = 0
    @Published var message: String = ""
    @Published var isMonitoring: Bool = true
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        manager.startMonitoringConnectionStatus()
        setupNotificationObservers()
        setupMessageReceiver()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .watchUnreachable, object: nil, queue: .main) { _ in
            self.message = "Watch became unreachable"
        }
        NotificationCenter.default.addObserver(forName: .watchReachabilityChanged, object: nil, queue: .main) { _ in
            self.message = "Watch reachability changed"
        }
    }
    
    private func setupMessageReceiver() {
        manager.messagePublisher
            .sink { [weak self] message in
                if let heartRate = message["heartRate"] as? Double {
                    DispatchQueue.main.async {
                        self?.currentHeartRate = heartRate
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func toggleHeartRateMonitoring() {
        isMonitoring.toggle()
        if isMonitoring {
            sendMessageToWatch(["command": "startMonitoring"])
            message = "Starting heart rate monitoring..."
        } else {
            sendMessageToWatch(["command": "stopMonitoring"])
            message = "Stopping heart rate monitoring..."
        }
    }
    
    private func sendMessageToWatch(_ message: [String: Any]) {
        manager.sendMessage(message) { reply in
            print("Received reply: \(reply)")
        } errorHandler: { error in
            if let wcError = error as? WatchConnectivityError {
                switch wcError {
                case .sessionNotActivated:
                    self.message = "Session is not activated"
                case .watchNotReachable:
                    self.message = "Watch became unreachable"
                }
            } else {
                self.message = "Error sending message: \(error.localizedDescription)"
            }
        }
    }
}
