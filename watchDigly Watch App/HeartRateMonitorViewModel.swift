import Foundation
import HealthKit
import WatchConnectivity
import Combine

class HeartRateMonitorViewModel: NSObject, ObservableObject {
    private let healthStore = HKHealthStore()
    private var query: HKQuery?
    private var timer: Timer?
    
    @Published var currentHeartRate: Double = 0
    
    override init() {
        super.init()
        setupWCSession()
        requestAuthorization()
    }
        
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    private func requestAuthorization() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { success, error in
            if success {
                self.startHeartRateQuery()
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func startHeartRateQuery() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.processHeartRateSamples(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.processHeartRateSamples(samples)
        }
        
        healthStore.execute(query)
        self.query = query
        
    }
    
    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            guard let mostRecentSample = heartRateSamples.last else { return }
            let heartRate = mostRecentSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            self.currentHeartRate = heartRate
            self.sendHeartRateToiOSApp()
        }
    }
        
    private func sendHeartRateToiOSApp() {
        if WCSession.default.isReachable {
            let data: [String: Any] = ["currentHeartRate": currentHeartRate]
            WCSession.default.sendMessage(data, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
    
    deinit {
            if let query = query {
                healthStore.stop(query)
            }
            timer?.invalidate()
        }
}

extension HeartRateMonitorViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle any messages received from the iOS app if needed
    }
}
