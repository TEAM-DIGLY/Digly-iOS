import Foundation

struct Question: Codable, Identifiable {
    let id: Int
    let email: String
    let title: String
    let content: String
}

struct CreateQuestionRequest: Codable {
    let email: String
    let title: String
    let content: String
}
