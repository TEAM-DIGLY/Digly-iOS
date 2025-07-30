import Foundation

protocol AuthRepositoryProtocol {
    func signIn(request: SignInRequest, socialToken: String) async throws -> SignInResponse
    func signUp(request: SignUpRequest, socialToken: String) async throws -> SignUpResponse
    func reissue(request: ReissueRequest, refreshToken: String) async throws -> ReissueResponse
}