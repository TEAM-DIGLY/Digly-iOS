import Foundation

final class MemberUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func getCurrentMember() async throws -> MemberResult {
        return try await memberRepository.getMember()
    }

    func updateMemberProfile(name: String, memberType: DiglyType) async throws -> MemberResult {
        return try await memberRepository.updateMember(name: name, memberType: memberType)
    }

    func withdrawMember(reason: String) async throws {
        return try await memberRepository.deleteMember(withdrawDesc: reason)
    }

    func checkDuplicateNameOnServer(_ name: String) async throws {
        try await memberRepository.validateDuplicateName(name: name)
    }

    func validateMemberName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               name.count >= 2 && name.count <= 10
    }
}
