import Foundation

final class MemberRepository: MemberRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getMember() async throws -> MemberResponse {
        return try await networkAPI.request(MemberEndpoint.getMember)
    }
    
    func updateMember(request: UpdateMemberRequest) async throws -> MemberResponse {
        return try await networkAPI.request(
            MemberEndpoint.putMember,
            parameters: request.toDictionary()
        )
    }
    
    func deleteMember(request: DeleteMemberRequest) async throws {
        let _: EmptyResponse = try await networkAPI.request(
            MemberEndpoint.patchMember,
            parameters: request.toDictionary()
        )
    }
}

struct EmptyResponse: Codable {}