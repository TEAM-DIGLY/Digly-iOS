import Foundation

actor TokenManager {
    static let shared = TokenManager()
    
    private var currentRefreshTask: Task<Bool, Never>?
    private let authUseCase = AuthUseCase()
    
    private init() {}
    
    func ensureValidToken() async -> Bool {
        if let currentTask = currentRefreshTask {
            return await currentTask.value
        }
        
        let refreshTask = Task { () -> Bool in
            await self.performTokenRefresh()
        }
        
        currentRefreshTask = refreshTask
        let result = await refreshTask.value
        currentRefreshTask = nil
        
        return result
    }
    
    func refreshTokens() async -> Bool {
        await performTokenRefresh()
    }
    
    func clearTokens() {
        KeychainManager.shared.clearTokens()
        currentRefreshTask?.cancel()
        currentRefreshTask = nil
    }
    
    private func performTokenRefresh() async -> Bool {
        guard let refreshToken = KeychainManager.shared.getRefreshToken(),
              !refreshToken.isEmpty else {
            return false
        }
        
        do {
            _ = try await authUseCase.reissueToken()
            return true
        } catch {
            await MainActor.run {
                AuthManager.shared.logout()
            }
            return false
        }
    }
}
