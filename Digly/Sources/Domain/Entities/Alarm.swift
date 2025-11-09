import Foundation

struct Alarm: Identifiable, Codable {
    let id: String
    let diglyType: DiglyType
    let title: String
    let message: String
    let date: Date
}
