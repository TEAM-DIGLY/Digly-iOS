import Foundation

enum OnboardingType: String, Codable {
    case main = "MAIN"
}

struct OnboardingVisibility {
    let onboardingType: OnboardingType
    let isVisible: Bool
}
