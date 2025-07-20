import Foundation

struct Alarm: Identifiable {
    let id = UUID()
    let diglyType: DiglyType
    let title: String
    let message: String
    let date: Date
} 