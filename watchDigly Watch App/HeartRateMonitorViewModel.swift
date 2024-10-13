import Foundation
import HealthKit
import WatchConnectivity

class HeartRateMonitorViewModel: NSObject, ObservableObject {
    private let healthStore = HKHealthStore()
    private var observerQuery: HKObserverQuery?
    private var anchoredObjectQuery: HKAnchoredObjectQuery?
    private var anchor: HKQueryAnchor?
    private var timer: Timer?
    private var session: WCSession?
    
    @Published var connectionStatus: ConnectionStatus = .checking
    @Published var currentHeartRate: Double = 0
    @Published var maxHeartRateLastMinute: Double = 0
    
    private var heartRatesThisMinute: [Double] = []
    private var lastSyncTime: Date = Date()
    
    enum ConnectionStatus: String {
        case checking = "연결 확인 중"
        case connected = "연결됨"
        case disconnected = "연결 끊김"
        case error = "연결 오류"
        case unreachable = "unreachable"
    }
    
    override init() {
        super.init()
        setupWCSession()
        requestAuthorization()
    }
    
    private func setupWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    private func requestAuthorization() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { [weak self] success, error in
            if success {
                self?.setupQueries()
                self?.startMinuteTimer()
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupQueries() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // ObserverQuery 설정
        observerQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] query, completionHandler, error in
            if let error = error {
                print("Observer Query error: \(error.localizedDescription)")
            } else {
                // 초기 데이터 설정
                self?.fetchLatestHeartRate()
            }
            completionHandler()
        }
        
        // AnchoredObjectQuery 설정
        anchoredObjectQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: anchor, limit: HKObjectQueryNoLimit) { [weak self] (query, samples, deletedObjects, newAnchor, error) in
            self?.processHeartRateSamples(samples)
            self?.anchor = newAnchor
        }
        
        anchoredObjectQuery?.updateHandler = { [weak self] (query, samples, deletedObjects, newAnchor, error) in
            self?.processHeartRateSamples(samples)
            self?.anchor = newAnchor
        }
        
        if let observerQuery = observerQuery, let anchoredObjectQuery = anchoredObjectQuery {
            healthStore.execute(observerQuery)
            healthStore.execute(anchoredObjectQuery)
            
            // 백그라운드 업데이트 활성화
            healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
                if let error = error {
                    print("Failed to enable background delivery: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchLatestHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-10), end: nil, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] (query, samples, error) in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            
            DispatchQueue.main.async {
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                self?.processNewHeartRate(heartRate)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            for sample in samples {
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                self.processNewHeartRate(heartRate)
            }
        }
    }
    
    private func processNewHeartRate(_ heartRate: Double) {
        self.currentHeartRate = heartRate
        self.heartRatesThisMinute.append(heartRate)
        self.maxHeartRateLastMinute = max(self.maxHeartRateLastMinute, heartRate) // TODO: 로직 개선
        sendMessageToiOSApp(message: ["heartRate": heartRate])
    }
    
    private func startMinuteTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                sendMessageToiOSApp(message: ["maxHeartRate": heartRatesThisMinute.max() ?? maxHeartRateLastMinute]) // TODO: 로직 개선
                
                maxHeartRateLastMinute = 0
                heartRatesThisMinute.removeAll()
                lastSyncTime = Date()
            }
        }
        
        private func sendMessageToiOSApp(message: [String: Any]) {
            guard let session = session, session.isReachable else {
                self.connectionStatus = .unreachable
                return
            }
            
            session.sendMessage(message, replyHandler: nil) { error in
                self.connectionStatus = .error
                print("Error sending message to iOS app: \(error.localizedDescription)")
            }
        }
        
        deinit {
            timer?.invalidate()
            if let query = observerQuery {
                healthStore.stop(query)
            }
            if let query = anchoredObjectQuery {
                healthStore.stop(query)
            }
        }
    }

extension HeartRateMonitorViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            self.connectionStatus = .error
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            self.connectionStatus = .connected
            print("WCSession activated successfully")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // iOS 앱으로부터 메시지를 받았을 때의 처리
        print("Received message from iOS app: \(message)")
    }
}
