import Foundation

protocol QuestionRepositoryProtocol {
    func createQuestion(email: String, title: String, content: String) async throws -> QuestionResult
}