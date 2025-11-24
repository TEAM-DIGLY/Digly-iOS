import Foundation

protocol OnboardingRepositoryProtocol {
    func getOnboardingVisible(type: OnboardingType) async throws -> OnboardingVisibility
    func updateOnboardingVisible(type: OnboardingType) async throws
}
