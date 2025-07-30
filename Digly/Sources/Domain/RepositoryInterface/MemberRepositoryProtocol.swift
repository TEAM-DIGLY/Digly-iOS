import Foundation

protocol MemberRepositoryProtocol {
    func getMember() async throws -> MemberResponse
    func updateMember(request: UpdateMemberRequest) async throws -> MemberResponse
    func deleteMember(request: DeleteMemberRequest) async throws
}