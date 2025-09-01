import Foundation

actor TokenManager {
    static let shared = TokenManager()
    
    private var currentRefreshTask: Task<Bool, Never>?
    
    private init() {}
    
    func ensureValidToken() async -> Bool {
        if let currentTask = currentRefreshTask {
            return await currentTask.value
        }
        
        let refreshTask = Task { () -> Bool in
            guard let accessToken = KeychainManager.shared.getAccessToken(),
                  let refreshToken = KeychainManager.shared.getRefreshToken(),
                  !accessToken.isEmpty, !refreshToken.isEmpty else {
                return false
            }
            
            // TODO: 실제 토큰 검증 API 호출 구현 필요
            // 현재는 토큰 존재 여부만 확인
            return true
        }
        
        currentRefreshTask = refreshTask
        let result = await refreshTask.value
        currentRefreshTask = nil
        
        return result
    }
    
    func refreshTokens() async -> Bool {
        guard let refreshToken = KeychainManager.shared.getRefreshToken(),
              !refreshToken.isEmpty else {
            return false
        }
        
        // TODO: 실제 토큰 갱신 API 호출 구현 필요
        // 현재는 기존 토큰 유지
        return true
    }
    
    func clearTokens() {
        KeychainManager.shared.clearTokens()
        currentRefreshTask?.cancel()
        currentRefreshTask = nil
    }
}
