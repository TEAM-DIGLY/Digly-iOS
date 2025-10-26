import Foundation

// MARK: - POST /api/v1/question
struct PostQuestionRequest: Codable {
    let email: String
    let title: String
    let content: String
}

struct PostQuestionResponse: BaseResponse {
    let statusCode: Int?
    let message: String?
    let id: Int
    let email: String
    let title: String
    let content: String

    func toDomain() -> QuestionResult {
        QuestionResult(
            id: id,
            email: email,
            title: title,
            content: content
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
