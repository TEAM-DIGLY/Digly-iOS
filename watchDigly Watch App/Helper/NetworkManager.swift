//
//  NetworkManager.swift
//  digly
//
//  Created by Neoself on 10/25/24.
//
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            if path.status == .satisfied {
                // 네트워크 연결되면 pending 데이터 전송 시도
                print("watchOS: syncPendingData through Network Manager")
                HeartRateSyncManager.shared.syncPendingData()
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
