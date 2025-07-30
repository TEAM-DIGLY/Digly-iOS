import Foundation
import Network

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published private(set) var isConnected = true
    @Published private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                self?.isConnected = isConnected
                
                if path.usesInterfaceType(.wifi) {
                    self?.connectionType = .wifi
                } else if path.usesInterfaceType(.cellular) {
                    self?.connectionType = .cellular
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self?.connectionType = .ethernet
                } else {
                    self?.connectionType = .unknown
                }
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}