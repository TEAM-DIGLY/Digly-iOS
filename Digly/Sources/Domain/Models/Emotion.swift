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
            return Color("emotion/distressed")
        case .excited:
            return Color("emotion/excited")
        case .glad:
            return Color("emotion/glad")
        case .gloomy:
            return Color("emotion/gloomy")
        case .relaxed:
            return Color("emotion/relaxed")
        case .satisfied:
            return Color("emotion/satisfied")
        }
    }

    var color50: Color {
        switch self {
        case .distressed:
            return Color("emotion/distressed50")
        case .excited:
            return Color("emotion/excited50")
        case .glad:
            return Color("emotion/glad50")
        case .gloomy:
            return Color("emotion/gloomy50")
        case .relaxed:
            return Color("emotion/relaxed50")
        case .satisfied:
            return Color("emotion/satisfied50")
        }
    }
}
