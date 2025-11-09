import Foundation

// MARK: - POST /api/v1/question
struct PostQuestionRequest: Codable {
    let email: String
    let title: String
    let content: String
}

struct PostQuestionResponse: Codable {
    let status: Int
    let message: String
    let data: QuestionData

    struct QuestionData: Codable {
        let id: Int
        let email: String
        let title: String
        let content: String
    }

    func toDomain() -> QuestionResult {
        QuestionResult(
            id: data.id,
            email: data.email,
            title: data.title,
            content: data.content
        )
    }
}

// MARK: - Domain Results
struct QuestionResult {
    let id: Int
    let email: String
    let title: String
    let content: String
}
