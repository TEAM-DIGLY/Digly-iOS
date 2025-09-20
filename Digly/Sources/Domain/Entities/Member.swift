import Foundation

struct Member: Codable, Identifiable {
    let id: Int
    let name: String
    let platformId: String?
    let platformType: PlatformType
    let memberType: MemberType
    let memberStatus: MemberStatus
    let withdrawDesc: String?
}

struct MemberResponse: Codable {
    let id: Int
    let name: String
    let platformType: PlatformType
    let memberType: MemberType
}

struct UpdateMemberRequest: Codable {
    let name: String
    let memberType: MemberType
}

struct DeleteMemberRequest: Codable {
    let withdrawDesc: String
}
