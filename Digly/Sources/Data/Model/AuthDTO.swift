import Foundation

// MARK: - POST /api/v1/auth/login
struct PostAuthLoginRequest: Codable {
    let platform: String

    init(platformType: PlatformType) {
        self.platform = platformType.rawValue
    }
}

struct PostAuthLoginResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String?
    let memberType: String?
    let accessToken: String
    let refreshToken: String

    func toDomain() -> SignInResult {
        SignInResult(
            id: id,
            name: name,
            memberType: memberType.flatMap { DiglyType(rawValue: $0) },
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}

// MARK: - POST /api/v1/auth/signup
struct PostAuthSignUpRequest: Codable {
    let name: String
    let memberType: String

    init(name: String, memberType: DiglyType) {
        self.name = name
        self.memberType = memberType.rawValue
    }
}

struct PostAuthSignUpResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String
    let memberType: String

    func toDomain() -> SignUpResult {
        SignUpResult(
            id: id,
            name: name,
            memberType: DiglyType(rawValue: memberType) ?? .collector
        )
    }
}

// MARK: - POST /api/v1/auth/reissue
/// - Note: `RequestDTO 불필요` (Authorization header에 refreshToken 전달)
struct PostAuthReissueResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let accessToken: String
    let refreshToken: String

    func toDomain() -> ReissueResult {
        ReissueResult(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}

// MARK: - Domain Results
struct SignInResult {
    let id: Int
    let name: String?
    let memberType: DiglyType?
    let accessToken: String
    let refreshToken: String
}

struct SignUpResult {
    let id: Int
    let name: String
    let memberType: DiglyType
}

struct ReissueResult {
    let accessToken: String
    let refreshToken: String
}

