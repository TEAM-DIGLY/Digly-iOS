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

    func signIn(platform: PlatformType, socialToken: String) async throws -> SignInResult {
        return try await authRepository.signIn(platform: platform, socialToken: socialToken)
    }

    func signUp(name: String, diglyType: DiglyType, accessToken: String) async throws -> SignUpResult {
        return try await authRepository.signUp(name: name, memberType: diglyType, accessToken: accessToken)
    }

    func reissueToken() async throws -> ReissueResult {
        guard let refreshToken = keychainManager.getRefreshToken() else {
            throw APIError.unauthorized
        }

        let result = try await authRepository.reissue(refreshToken: refreshToken)
        keychainManager.saveTokens(result.accessToken, result.refreshToken)
        return result
    }

    func logout() async {
        UserDefaults.standard.removeObject(forKey: "currentMemberId")
        await AuthManager.shared.logout()
    }

}
