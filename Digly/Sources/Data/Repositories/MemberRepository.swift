import Foundation

final class MemberRepository: MemberRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func getMember() async throws -> MemberResult {
        let response: GetMemberResponse = try await networkAPI.request(MemberEndpoint.getMember)
        return response.toDomain()
    }

    func updateMember(name: String, memberType: DiglyType) async throws -> MemberResult {
        let request = PutMemberRequest(name: name, memberType: memberType)
        let response: PutMemberResponse = try await networkAPI.request(
            MemberEndpoint.putMember,
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }

    func deleteMember(withdrawDesc: String) async throws {
        let request = PatchMemberRequest(withdrawDesc: withdrawDesc)
        let _: PatchMemberResponse = try await networkAPI.request(
            MemberEndpoint.patchMember,
            parameters: request.toDictionary()
        )
    }

    func validateDuplicateName(name: String) async throws {
        let _: GetMemberNameValidationResponse = try await networkAPI.request(
            MemberEndpoint.validateName,
            queryParameters: ["name": name]
        )
    }
}
