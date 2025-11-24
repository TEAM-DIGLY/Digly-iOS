import Foundation

final class OnboardingRepository: OnboardingRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func getOnboardingVisible(type: OnboardingType) async throws -> OnboardingVisibility {
        let response: GetOnboardingResponse = try await networkAPI.request(
            OnboardingEndpoint.get(onboardingType: type.rawValue),
            queryParameters: ["onboardingType": type.rawValue]
        )
        return response.toDomain()
    }

    func updateOnboardingVisible(type: OnboardingType) async throws {
        let _: PatchOnboardingResponse = try await networkAPI.request(
            OnboardingEndpoint.updateVisible(onboardingType: type.rawValue),
            queryParameters: ["onboardingType": type.rawValue]
        )
    }
}
