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
        let apiResponse = try await authRepository.signIn(platform: platform, socialToken: socialToken)
        
        saveMemberId(apiResponse.data.id)
        
        return apiResponse.data
    }
    
    func signUp(name: String, memberType: MemberType, accessToken: String) async throws -> SignUpResponse {
        let request = SignUpRequest(name: name, memberType: memberType)
        return try await authRepository.signUp(request: request, accessToken: accessToken)
    }
    
    func reissueToken() async throws -> ReissueResponse {
        guard let refreshToken = keychainManager.getRefreshToken(),
              let memberId = getCurrentMemberId() else {
            throw APIError.unauthorized
        }
        
        let request = ReissueRequest(memberId: memberId)
        let response = try await authRepository.reissue(request: request, refreshToken: refreshToken)
        
        keychainManager.saveTokens(response.accessToken, response.refreshToken)
        
        return response
    }
    
    func logout() async {
        UserDefaults.standard.removeObject(forKey: "currentMemberId")
        await AuthManager.shared.logout()
    }
    
    private func saveMemberId(_ memberId: Int) {
        UserDefaults.standard.set(memberId, forKey: "currentMemberId")
    }
    
    private func getCurrentMemberId() -> Int64? {
        return UserDefaults.standard.object(forKey: "currentMemberId") as? Int64
    }
}
