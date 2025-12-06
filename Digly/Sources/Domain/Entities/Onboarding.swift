import Foundation

enum OnboardingType: String, Codable {
    case main = "MAIN"
    case note = "NOTE"
}

struct OnboardingVisibility {
    let onboardingType: OnboardingType
    let isVisible: Bool
}
