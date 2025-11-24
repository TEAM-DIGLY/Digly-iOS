import Foundation

// MARK: - GET /api/v1/onboarding
struct GetOnboardingResponse: Codable {
    let status: Int
    let message: String
    let data: OnboardingData

    struct OnboardingData: Codable {
        let onboardingType: String
        let isVisible: Bool

        func toDomain() -> OnboardingVisibility {
            OnboardingVisibility(
                onboardingType: OnboardingType(rawValue: onboardingType) ?? .main,
                isVisible: isVisible
            )
        }
    }

    func toDomain() -> OnboardingVisibility {
        data.toDomain()
    }
}

// MARK: - PATCH /api/v1/onboarding
struct PatchOnboardingResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}
