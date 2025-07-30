import Foundation

protocol QuestionRepositoryProtocol {
    func createQuestion(request: CreateQuestionRequest) async throws -> Question
}