import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func signIn(platform: PlatformType, socialToken: String) async throws -> APIResponse<SignInResponse> {
        let params = ["platform" : platform.rawValue]
        
        return try await networkAPI.request(AuthEndpoint.postLogin(socialToken), parameters: params)
    }
    
    func signUp(request: SignUpRequest, accessToken: String) async throws -> APIResponse<SignUpResponse> {
        let params = [
            "name": request.name,
            "memberType": request.diglyType.rawValue
        ]
        
        return try await networkAPI.request(
            AuthEndpoint.postSignup(accessToken),
            parameters: params
        )
    }
    
    func reissue(refreshToken: String) async throws -> APIResponse<ReissueResponse> {
        return try await networkAPI.request(AuthEndpoint.postReissue(refreshToken))
    }
}
