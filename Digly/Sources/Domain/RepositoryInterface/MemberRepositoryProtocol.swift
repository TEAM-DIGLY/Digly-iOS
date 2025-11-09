import Foundation

protocol MemberRepositoryProtocol {
    func getMember() async throws -> MemberResult
    func updateMember(name: String, memberType: DiglyType) async throws -> MemberResult
    func deleteMember(withdrawDesc: String) async throws
    func validateDuplicateName(name: String) async throws
}
