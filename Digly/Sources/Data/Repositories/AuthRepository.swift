import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func signIn(request: SignInRequest, socialToken: String) async throws -> SignInResponse {
        return try await networkAPI.request(
            AuthEndpoint.postLogin(socialToken),
            parameters: request.toDictionary()
        )
    }
    
    func signUp(request: SignUpRequest, socialToken: String) async throws -> SignUpResponse {
        return try await networkAPI.request(
            AuthEndpoint.postSignup(socialToken),
            parameters: request.toDictionary()
        )
    }
    
    func reissue(request: ReissueRequest, refreshToken: String) async throws -> ReissueResponse {
        return try await networkAPI.request(
            AuthEndpoint.postReissue(refreshToken),
            parameters: request.toDictionary()
        )
    }
}