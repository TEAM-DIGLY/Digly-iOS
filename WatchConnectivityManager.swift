import WatchConnectivity
import Combine

// 커스텀 에러 타입
enum WatchConnectivityError: Error {
    case sessionNotActivated
    case watchNotReachable
}

// 노티피케이션 이름 확장
extension Notification.Name {
    static let watchUnreachable = Notification.Name("WatchUnreachableNotification")
    static let watchReachabilityChanged = Notification.Name("WatchReachabilityChangedNotification")
}

class WatchConnectivityManager: NSObject {
    static let shared = WatchConnectivityManager()
    
    private var session: WCSession?
    private var timer: Timer?
    
    var iOSMessageReceiver: (([String: Any]) -> Void)?
    var watchMessageReceiver: (([String: Any]) -> Void)?
    
    
    private override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    // 5초마다 연결 상태 확인 시작
    func startMonitoringConnectionStatus() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkConnectionStatus()
        }
    }
    
    // 주기적인 연결 상태 확인 중지
    func stopMonitoringConnectionStatus() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkConnectionStatus() {
        guard let session = session else { return }
        
        if session.activationState == .activated {
            if session.isReachable  == true {
                print("Watch is reachable")
            } else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .watchUnreachable, object: nil)
                }
            }
        } else {
            self.session?.activate()
        }
    }
    
    // 메시지 전송 메서드
    func sendMessage(_ message: [String: Any], errorHandler: ((Error) -> Void)? = nil) {
        guard let session = session, session.isReachable else {
            DispatchQueue.main.async {
                errorHandler?(WatchConnectivityError.watchNotReachable)
            }
            return
        }
        
        session.sendMessage(message, replyHandler: nil) { error in
            DispatchQueue.main.async {
                errorHandler?(error)
            }
        }
    }
}

// WCSessionDelegate 메서드들
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
#if os(iOS)
            self?.iOSMessageReceiver?(message)
#else
            self?.watchMessageReceiver?(message)
#endif
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        print("Session activated with state: \(activationState.rawValue)")
    }
    
    // 연결 상태 변화를 감지하고 노티피케이션을 발송
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .watchReachabilityChanged, object: nil)
        }
    }
    
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) { }
    public func sessionDidDeactivate(_ session: WCSession) {
        self.session?.activate()
    }
#endif
}
