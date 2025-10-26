import Foundation

// MARK: - GET /api/v1/member
/// - Note: `RequestDTO 불필요`
struct GetMemberResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String
    let platformType: String
    let memberType: String

    func toDomain() -> MemberResult {
        MemberResult(
            id: id,
            name: name,
            platformType: PlatformType(rawValue: platformType) ?? .kakao,
            memberType: DiglyType(rawValue: memberType) ?? .collection
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

struct PutMemberResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let name: String
    let platformType: String
    let memberType: String

    func toDomain() -> MemberResult {
        MemberResult(
            id: id,
            name: name,
            platformType: PlatformType(rawValue: platformType) ?? .kakao,
            memberType: DiglyType(rawValue: memberType) ?? .collection
        )
    }
}

// MARK: - PATCH /api/v1/member
struct PatchMemberRequest: Codable {
    let withdrawDesc: String
}

struct PatchMemberResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let result: EmptyResult?
}

// MARK: - GET /api/v1/member/name
/// - Note: `RequestDTO 불필요` (query parameter로 name 전달)
struct GetMemberNameValidationResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let result: EmptyResult?
}

// MARK: - Domain Results
struct MemberResult {
    let id: Int
    let name: String
    let platformType: PlatformType
    let memberType: DiglyType
}
