import Foundation

final class QuestionRepository: QuestionRepositoryProtocol {
    private let networkAPI: NetworkAPI

    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func createQuestion(email: String, title: String, content: String) async throws -> QuestionResult {
        let request = PostQuestionRequest(email: email, title: title, content: content)
        let response: PostQuestionResponse = try await networkAPI.request(
            QuestionEndpoint.postQuestion,
            parameters: request.toDictionary()
        )
        return response.toDomain()
    }
}