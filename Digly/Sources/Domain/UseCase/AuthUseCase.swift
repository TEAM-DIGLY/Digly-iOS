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
    
    func signIn(platform: PlatformType, socialToken: String) async throws -> APIResponse<SignInResponse> {
        return try await authRepository.signIn(platform: platform, socialToken: socialToken)
    }
    
    func signUp(name: String, diglyType: DiglyType, accessToken: String) async throws -> SignUpResponse {
        let request = SignUpRequest(name: name, diglyType: diglyType)
        return try await authRepository.signUp(request: request, accessToken: accessToken)
    }
    
    func reissueToken() async throws -> ReissueResponse {
        guard let refreshToken = keychainManager.getRefreshToken() else {
            throw APIError.unauthorized
        }
        
        let response = try await authRepository.reissue(refreshToken: refreshToken)
        keychainManager.saveTokens(response.accessToken, response.refreshToken)
        return response
    }
    
    func logout() async {
        UserDefaults.standard.removeObject(forKey: "currentMemberId")
        await AuthManager.shared.logout()
    }
    
}
