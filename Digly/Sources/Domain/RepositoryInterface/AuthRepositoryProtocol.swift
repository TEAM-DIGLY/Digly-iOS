import Foundation

protocol AuthRepositoryProtocol {
    func signIn(platform: PlatformType, socialToken: String) async throws -> APIResponse<SignInResponse>
    func signUp(request: SignUpRequest, accessToken: String) async throws -> SignUpResponse
    func reissue(refreshToken: String) async throws -> ReissueResponse
}
