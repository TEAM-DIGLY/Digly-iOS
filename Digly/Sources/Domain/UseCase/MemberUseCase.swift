import Foundation

final class MemberUseCase {
    private let memberRepository: MemberRepositoryProtocol
    
    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func getCurrentMember() async throws -> MemberResponse {
        return try await memberRepository.getMember()
    }
    
    func updateMemberProfile(name: String, memberType: MemberType) async throws -> MemberResponse {
        let request = UpdateMemberRequest(name: name, memberType: memberType)
        return try await memberRepository.updateMember(request: request)
    }
    
    func withdrawMember(reason: String) async throws {
        let request = DeleteMemberRequest(withdrawDesc: reason)
        return try await memberRepository.deleteMember(request: request)
    }
    
    func validateMemberName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               name.count >= 2 && name.count <= 10
    }
}
