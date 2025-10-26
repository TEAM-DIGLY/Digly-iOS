import Foundation

protocol AuthRepositoryProtocol {
    func signIn(platform: PlatformType, socialToken: String) async throws -> SignInResult
    func signUp(name: String, memberType: DiglyType, accessToken: String) async throws -> SignUpResult
    func reissue(refreshToken: String) async throws -> ReissueResult
}
