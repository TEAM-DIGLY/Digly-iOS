import Foundation

struct Question: Codable, Identifiable {
    let id: Int64
    let email: String
    let title: String
    let content: String
}

struct CreateQuestionRequest: Codable {
    let email: String
    let title: String
    let content: String
}