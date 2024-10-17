import Foundation
import HealthKit
import Combine
import WatchConnectivity
import Alamofire

class HeartRateMonitorViewModel: NSObject, ObservableObject {
    @Published var currentHeartRate: Double = 0
    private var maxHeartRate: Double = 0
    @Published var isMonitoring: Bool = false
    
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var anchoredObjectQuery: HKAnchoredObjectQuery?
    private var timer: Timer?
    @Published var isPermissionGranted: Bool = false
    
    private let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    
    override init() {
        super.init()
        setupWatchConnectivity()
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func startMonitoring() {
        requestAuthorization { success in
            guard success else { return }
            self.isPermissionGranted = true
            self.startWorkoutSession()
            self.setupAnchoredObjectQuery()
            self.startTimer()
            self.enableBackgroundDelivery()
            DispatchQueue.main.async {
                self.isMonitoring = true
            }
        }
    }
    
    func stopMonitoring() {
        stopWorkoutSession()
        stopAnchoredObjectQuery()
        stopTimer()
        DispatchQueue.main.async {
            self.isMonitoring = false
            self.currentHeartRate = 0
        }
    }
    
    // 백그라운드에도 새로운 데이터 받을 수 있게 함.
    private func enableBackgroundDelivery() {
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery: \(error)")
            }
        }
    }
    
    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToShare: Set = [HKObjectType.workoutType()]
        let typesToRead: Set = [heartRateType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
            completion(success)
        }
    }
    
    // 백그라운드에서 장시간 실행될 수 있게끔 운동세션을 시작.
    private func startWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            healthStore.start(workoutSession!)
        } catch {
            print("Failed to start workout session: \(error)")
        }
    }
    
    private func stopWorkoutSession() {
        guard let workoutSession = workoutSession else { return }
        healthStore.end(workoutSession)
        self.workoutSession = nil
    }
    
    private func setupAnchoredObjectQuery() {
        // 실시간으로 새로운 데이터 바로 받기 위해 하기 유형 사용
        // TODO: Anchor 설정하여, 오랜시간 미사용 후, 다시 켰을때 이전 데이터들 한번에 처리하지 않게끔.
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples)
        }
        
        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples)
        }
        
        anchoredObjectQuery = query
        healthStore.execute(query)
    }
    
    private func stopAnchoredObjectQuery() {
        if let query = anchoredObjectQuery {
            healthStore.stop(query)
            anchoredObjectQuery = nil
        }
    }
    
    // MARK: HKAnchoredObjectQuery와는 별개로, 타이머 그리고, HKSampleQuery를 사용해 정기적으로 최신 심박수 데이터를 가져옴. 예비 데이터 추출기.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.fetchLatestHeartRate()
            self?.sendMaxHeartRateToServer(self?.maxHeartRate ?? -10.0)
            self?.maxHeartRate = 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: HKAnchoredObjectQuery 초기화 및 새로운 샘플이 HealthStore로부터 전송올때, 실행됨.
    // 심박수 정보 currentHeartRate에 저장하고, iOS에 전달
    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        
        for sample in samples {
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self.currentHeartRate = heartRate
                self.maxHeartRate = max(self.maxHeartRate, heartRate)
            }
            sendMessageToIOS(["heartRate":heartRate,
                              "dataType":"HKAnchoredObjectQuery",
                              "lastUpdated":Date().description
                             ])
        }
    }
    
    private func fetchLatestHeartRate() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] query, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self?.currentHeartRate = heartRate
                self?.maxHeartRate = max(self?.maxHeartRate ?? -10.0 , heartRate)
            }
            self?.sendMessageToIOS(["heartRate":heartRate,
                                    "dataType":"HKSampleQuery",
                                    "lastUpdated":Date().description
                                   ])
        }
        healthStore.execute(query)
    }
    
    private func sendMaxHeartRateToServer(_ maxHeartRate : Double) {
        print("sendMaxHeartRateToServer")
        let baseURL = "http://43.201.140.227:8080/api"
        let endpoint = "/heartRate"
        
        AF.request(baseURL+endpoint,
                   method: .post,
                   parameters: ["heartRate": maxHeartRate],
                   encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: String.self) { response in
            switch response.result {
            case .success(let sentHeartRateId):
                print("success\(sentHeartRateId)")
            case .failure(let error):
                print("Error sending HeartRate: \(error.localizedDescription)")
            }
        }
    }
    
    private func sendMessageToIOS(_ message: [String:Any]) {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Failed to send heart rate: \(error.localizedDescription)")
        }
    }
}

extension HeartRateMonitorViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let command = message["command"] as? String {
            DispatchQueue.main.async {
                switch command {
                case "startMonitoring":
                    if !self.isMonitoring {
                        self.startMonitoring()
                    }
                case "stopMonitoring":
                    if self.isMonitoring {
                        self.stopMonitoring()
                    }
                default:
                    print("Unknown command received: \(command)")
                }
            }
        }
    }
}
