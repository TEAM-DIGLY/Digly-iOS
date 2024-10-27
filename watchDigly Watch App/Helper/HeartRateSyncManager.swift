import Foundation
import UIKit
import CoreData
import Alamofire

class HeartRateSyncManager {
    static let shared = HeartRateSyncManager()
    private let context = HeartRateDataModel.shared.context
    private let syncQueue = DispatchQueue(label: "com.heartrate.sync", qos: .utility)
    private var isSyncing = false
    
    // 즉시 동기화가 필요한 경우 호출
    func forceSyncPendingData() {
        syncPendingData(forced: true)
    }
    
    func syncPendingData(forced: Bool = false) {
        guard !isSyncing || forced else { return }
        
        syncQueue.async { [weak self] in
            self?.isSyncing = true
            
            let fetchRequest: NSFetchRequest<HeartRateEntity> = HeartRateEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isSynced == NO")
            
            do {
                let unsyncedData = try self?.context.fetch(fetchRequest)
                guard let dataToSync = unsyncedData else { return }
                
                for heartRateData in dataToSync {
                    self?.sendToServer(heartRate: Int(heartRateData.heartRate), time: heartRateData.timestamp?.timeStampFormat ?? "timeStamp invalid") { success in
                        if success {
                            self?.context.perform {
                                heartRateData.isSynced = true
                                try? self?.context.save()
                            }
                        }
                    }
                }
                
                HeartRateDataModel.shared.deleteOldData()
            } catch {
                print("Failed to fetch unsynced data: \(error)")
            }
            self?.isSyncing = false
        }
    }
    
    private func sendToServer(heartRate: Int,time:String, completion: @escaping (Bool) -> Void) {
        let baseURL = "http://43.201.140.227:8080/api"
        let endpoint = "/heartRate"
        
        AF.request(baseURL + endpoint,
                  method: .post,
                  parameters: ["heartRate": "\(heartRate) \(time)"],
                  encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: String.self) { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("Error sending HeartRate: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func saveHeartRate(_ heartRate: Int, timestamp: Date = Date()) {
            context.perform {
                let heartRateEntity = HeartRateEntity(context: self.context)
                heartRateEntity.heartRate = Int64(heartRate)
                heartRateEntity.timestamp = timestamp
                heartRateEntity.isSynced = false
                
                do {
                    try self.context.save()
                    self.syncPendingData()
                } catch {
                    print("WatchOS - SaveHeartRate : \(error.localizedDescription)")
                }
            }
        }
}
