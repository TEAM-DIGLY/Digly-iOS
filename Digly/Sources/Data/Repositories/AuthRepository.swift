import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func signIn(platform: PlatformType, socialToken: String) async throws -> SignInResult {
        let request = PostAuthLoginRequest(platformType: platform)
        let response: PostAuthLoginResponse = try await networkAPI.request(
            AuthEndpoint.postLogin(socialToken),
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func signUp(name: String, memberType: DiglyType, accessToken: String) async throws -> SignUpResult {
        let request = PostAuthSignUpRequest(name: name, memberType: memberType)
        let response: PostAuthSignUpResponse = try await networkAPI.request(
            AuthEndpoint.postSignup(accessToken),
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func reissue(refreshToken: String) async throws -> ReissueResult {
        let response: PostAuthReissueResponse = try await networkAPI.request(
            AuthEndpoint.postReissue(refreshToken)
        )
        return response.toDomain()
    }
}
