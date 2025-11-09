import Foundation

// MARK: - POST /api/v1/auth/login
struct PostAuthLoginRequest: Codable {
    let platform: String

    init(platformType: PlatformType) {
        self.platform = platformType.rawValue
    }
}

struct PostAuthLoginResponse: Codable {
    let status: Int
    let message: String
    let data: LoginData

    struct LoginData: Codable {
        let id: Int
        let name: String?
        let memberType: String?
        let accessToken: String
        let refreshToken: String
    }

    func toDomain() -> SignInResult {
        SignInResult(
            id: data.id,
            name: data.name,
            memberType: data.memberType.flatMap { DiglyType(rawValue: $0) },
            accessToken: data.accessToken,
            refreshToken: data.refreshToken
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

struct PostAuthSignUpResponse: Codable {
    let status: Int
    let message: String
    let data: SignUpData

    struct SignUpData: Codable {
        let id: Int
        let name: String
        let memberType: String
    }

    func toDomain() -> SignUpResult {
        SignUpResult(
            id: data.id,
            name: data.name,
            memberType: DiglyType(rawValue: data.memberType) ?? .collector
        )
    }
}

// MARK: - POST /api/v1/auth/reissue
/// - Note: `RequestDTO 불필요` (Authorization header에 refreshToken 전달)
struct PostAuthReissueResponse: Codable {
    let status: Int
    let message: String
    let data: ReissueData

    struct ReissueData: Codable {
        let accessToken: String
        let refreshToken: String
    }

    func toDomain() -> ReissueResult {
        ReissueResult(
            accessToken: data.accessToken,
            refreshToken: data.refreshToken
        )
    }
}

// MARK: - Domain Results
struct SignInResult: Codable {
    let id: Int
    let name: String?
    let memberType: DiglyType?
    let accessToken: String
    let refreshToken: String
}

struct SignUpResult: Codable {
    let id: Int
    let name: String
    let memberType: DiglyType
}

struct ReissueResult: Codable {
    let accessToken: String
    let refreshToken: String
}

