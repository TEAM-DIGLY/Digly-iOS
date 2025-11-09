import Foundation

// MARK: - GET /api/v1/member
/// - Note: `RequestDTO 불필요`
struct GetMemberResponse: Codable {
    let status: Int
    let message: String
    let data: MemberData

    struct MemberData: Codable {
        let id: Int
        let name: String
        let platformType: String
        let memberType: String
    }

    func toDomain() -> MemberResult {
        MemberResult(
            id: data.id,
            name: data.name,
            platformType: PlatformType(rawValue: data.platformType) ?? .kakao,
            memberType: DiglyType(rawValue: data.memberType) ?? .collector
        )
    }
}

// MARK: - PUT /api/v1/member
struct PutMemberRequest: Codable {
    let name: String
    let memberType: String

    init(name: String, memberType: DiglyType) {
        self.name = name
        self.memberType = memberType.rawValue
    }
}

struct PutMemberResponse: Codable {
    let status: Int
    let message: String
    let data: MemberData

    struct MemberData: Codable {
        let id: Int
        let name: String
        let platformType: String
        let memberType: String
    }

    func toDomain() -> MemberResult {
        MemberResult(
            id: data.id,
            name: data.name,
            platformType: PlatformType(rawValue: data.platformType) ?? .kakao,
            memberType: DiglyType(rawValue: data.memberType) ?? .collector
        )
    }
}

// MARK: - PATCH /api/v1/member
struct PatchMemberRequest: Codable {
    let withdrawDesc: String
}

struct PatchMemberResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}

// MARK: - GET /api/v1/member/name
/// - Note: `RequestDTO 불필요` (query parameter로 name 전달)
struct GetMemberNameValidationResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}

// MARK: - Domain Results
struct MemberResult {
    let id: Int
    let name: String
    let platformType: PlatformType
    let memberType: DiglyType
}
