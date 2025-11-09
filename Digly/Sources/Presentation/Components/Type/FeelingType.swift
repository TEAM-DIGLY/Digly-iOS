enum Feeling: String, CaseIterable, Codable {
    case distressed
    case excited
    case joyful
    case sad
    case peaceful
    case satisfied
    
    var displayName: String {
        switch self {
        case .distressed:   "괴로운"
        case .excited:      "신난"
        case .joyful:       "즐거운"
        case .sad:          "슬픈"
        case .peaceful:     "평온한"
        case .satisfied:    "만족한"
        }
    }
}
