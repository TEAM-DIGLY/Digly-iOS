import Foundation

final class OnboardingUseCase {
    private let repository: OnboardingRepositoryProtocol

    init(repository: OnboardingRepositoryProtocol = OnboardingRepository()) {
        self.repository = repository
    }

    func getVisibility(type: OnboardingType = .main) async throws -> OnboardingVisibility {
        try await repository.getOnboardingVisible(type: type)
    }

    func updateVisibility(type: OnboardingType = .main) async throws {
        try await repository.updateOnboardingVisible(type: type)
    }
}
