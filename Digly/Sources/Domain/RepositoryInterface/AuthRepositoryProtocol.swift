import Foundation

protocol AuthRepositoryProtocol {
    func signIn(platform: PlatformType, socialToken: String) async throws -> APIResponse<SignInResponse>
    func signUp(request: SignUpRequest, accessToken: String) async throws -> APIResponse<SignUpResponse>
    func reissue(refreshToken: String) async throws -> APIResponse<ReissueResponse>
}
