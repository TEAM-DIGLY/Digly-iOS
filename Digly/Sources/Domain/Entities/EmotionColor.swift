import SwiftUI

enum EmotionColor: String, CaseIterable, Codable {
    case excited = "excited"
    case glad = "glad"
    case satisfied = "satisfied"
    case relaxed = "relaxed"
    case gloomy = "gloomy"
    case distressed = "distressed"

    var color: Color {
        switch self {
        case .excited:
            return Color("excited")
        case .glad:
            return Color("glad")
        case .satisfied:
            return Color("satisfied")
        case .relaxed:
            return Color("relaxed")
        case .gloomy:
            return Color("gloomy")
        case .distressed:
            return Color("distressed")
        }
    }

    var displayName: String {
        switch self {
        case .excited:
            return "신남"
        case .glad:
            return "기쁨"
        case .satisfied:
            return "만족"
        case .relaxed:
            return "편안함"
        case .gloomy:
            return "우울함"
        case .distressed:
            return "괴로움"
        }
    }

    static func fromRawValues(_ rawValues: [String]) -> [EmotionColor] {
        return rawValues.compactMap { EmotionColor(rawValue: $0) }
    }

    static func toRawValues(_ colors: [EmotionColor]) -> [String] {
        return colors.map { $0.rawValue }
    }
}