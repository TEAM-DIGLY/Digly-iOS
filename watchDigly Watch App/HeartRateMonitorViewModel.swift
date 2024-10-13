import Foundation
import HealthKit
import WatchConnectivity

class HeartRateMonitorViewModel: NSObject, ObservableObject {
    private let healthStore = HKHealthStore()
    private var query: HKAnchoredObjectQuery?
    private var anchor: HKQueryAnchor?
    private var reachabilityTimer: Timer?
    private var isReachable: Bool = false
    
    @Published var currentHeartRate: Double = 0
    @Published var isWCSessionSupported: Bool = false
    
    @Published var measurementStatus: MeasurementStatus = .notStarted
    @Published var connectionStatus: ConnectionStatus = .checking
    
    private var updateCount: Int = 0
    
    enum MeasurementStatus: String {
        case notStarted = "측정 시작 전"
        case measuring = "측정 중"
        case paused = "일시 중지됨"
        case error = "오류 발생"
    }
    
    enum ConnectionStatus: String {
        case checking = "연결 확인 중"
        case connected = "연결됨"
        case disconnected = "연결 끊김"
        case error = "연결 오류"
        case unreachable = "unreachable"
    }
    
    override init() {
        super.init()
        requestAuthorization()
        startReachabilityTimer()
    }
    
    private func startReachabilityTimer() {
        reachabilityTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.checkReachability()
        }
    }
    
    private func checkReachability() {
        let session = WCSession.default
        DispatchQueue.main.async {
            self.connectionStatus = session.isReachable ? .connected : .disconnected
            
            if !session.isReachable {
                self.handleUnreachableState()
            }
        }
    }
    
    private func handleUnreachableState() {
        print("iOS 앱과의 연결이 끊어졌습니다. 연결 상태를 확인해주세요.")
        connectionStatus = .unreachable
    }
    
    private func requestAuthorization() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.setupHeartRateQuery()
                    self?.measurementStatus = .measuring
                } else if let error = error {
                    print("HealthKit authorization failed: \(error.localizedDescription)")
                    self?.measurementStatus = .error
                }
            }
        }
    }
    
    private func setupHeartRateQuery() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: anchor, limit: HKObjectQueryNoLimit) { [weak self] (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            guard let self = self else { return }
            
            if let error = errorOrNil {
                print("HKAnchoredObjectQuery error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.measurementStatus = .error
                }
                return
            }
            self.anchor = newAnchor
            self.process(samples: samplesOrNil)
        }
        
        query.updateHandler = { [weak self] (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            guard let self = self else { return }
            
            if let error = errorOrNil {
                print("HKAnchoredObjectQuery update error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.measurementStatus = .error
                }
                return
            }
            self.anchor = newAnchor
            self.process(samples: samplesOrNil)
        }
        healthStore.execute(query)
        self.query = query
    }
    
    private func process(samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            for sample in samples {
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                self.currentHeartRate = heartRate
                self.updateCount += 1
                self.measurementStatus = .measuring
            }
            
            self.sendHeartRateToiOSApp()
        }
    }
    
    
    private func sendHeartRateToiOSApp() {
        guard isWCSessionSupported && isReachable else {
            print("iOS 앱과 통신할 수 없습니다. 연결 상태: \(connectionStatus.rawValue)")
            self.connectionStatus = .unreachable
            return
        }
        
        let data: [String: Any] = [
            "heartRate": currentHeartRate,
            "measurementStatus": measurementStatus.rawValue,
            "connectionStatus": connectionStatus.rawValue,
            "
        ]
        
        WCSession.default.sendMessage(data, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
            self.connectionStatus = .error
        }
    }
    
    deinit {
        if let query = query {
            healthStore.stop(query)
        }
        reachabilityTimer?.invalidate()
    }
}

extension HeartRateMonitorViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("WCSession activation failed with error: \(error.localizedDescription)")
                self.connectionStatus = .error
            } else {
                print("WCSession activated successfully")
                self.connectionStatus = activationState == .activated ? .connected : .disconnected
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            self.connectionStatus = session.isReachable ? .connected : .disconnected
            
            if !session.isReachable {
                self.handleUnreachableState()
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle any messages received from the iOS app if needed
    }
}
