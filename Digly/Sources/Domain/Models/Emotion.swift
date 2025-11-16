import SwiftUI

enum Emotion: String, CaseIterable {
    case distressed = "괴로운"
    case excited = "신난"
    case glad = "즐거운"
    case gloomy = "슬픈"
    case relaxed = "평온한"
    case satisfied = "만족한"

    var color: Color {
        switch self {
        case .distressed:
            return .distressed
        case .excited:
            return .excited
        case .glad:
            return .glad
        case .gloomy:
            return .gloomy
        case .relaxed:
            return .relaxed
        case .satisfied:
            return .satisfied
        }
    }

    var color50: Color {
        switch self {
        case .distressed:
            return .distressed50
        case .excited:
            return .excited50
        case .glad:
            return .glad50
        case .gloomy:
            return .gloomy50
        case .relaxed:
            return .relaxed50
        case .satisfied:
            return .satisfied50
        }
    }
}
