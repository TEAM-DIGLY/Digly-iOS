import Foundation

final class AuthUseCase {
    private let authRepository: AuthRepositoryProtocol
    private let keychainManager: KeychainManager
    
    init(
        authRepository: AuthRepositoryProtocol = AuthRepository(),
        keychainManager: KeychainManager = KeychainManager.shared
    ) {
        self.authRepository = authRepository
        self.keychainManager = keychainManager
    }
    
    func signIn(platform: PlatformType, socialToken: String) async throws -> SignInResponse {
        let response = try await authRepository.signIn(platform: platform, socialToken: socialToken)
        
        return response.data
    }
    
    func signUp(name: String, diglyType: DiglyType, accessToken: String) async throws -> SignUpResponse {
        let request = SignUpRequest(name: name, diglyType: diglyType)
        let response = try await authRepository.signUp(request: request, accessToken: accessToken)
        
        return response.data
    }
    
    func reissueToken() async throws -> ReissueResponse {
        guard let refreshToken = keychainManager.getRefreshToken() else {
            throw APIError.unauthorized
        }
        
        let response = try await authRepository.reissue(refreshToken: refreshToken)
        
        keychainManager.saveTokens(response.data.accessToken, response.data.refreshToken)
        
        return response.data
    }
    
    func logout() async {
        UserDefaults.standard.removeObject(forKey: "currentMemberId")
        await AuthManager.shared.logout()
    }
    
}
