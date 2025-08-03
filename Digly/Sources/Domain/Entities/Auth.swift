import Foundation

struct SignInRequest: Codable {
    let platform: String
    
    init(platformType: PlatformType) {
        self.platform = platformType.rawValue
    }
}

struct SignInResponse: Codable {
    let id: Int
    let name: String?
    let memberType: DiglyType?
    let accessToken: String
    let refreshToken: String
}

struct SignUpRequest: Codable {
    let name: String
    let diglyType: DiglyType
}

struct SignUpResponse: Codable {
    let id: Int
    let name: String
    let memberType: MemberType
}

struct ReissueRequest: Codable {
    let memberId: Int64
}

struct ReissueResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct CrawlingTicketsTitleResponse: Codable {
    let titleList: [String]
}
