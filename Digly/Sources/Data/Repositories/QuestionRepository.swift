import Foundation

final class QuestionRepository: QuestionRepositoryProtocol {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func createQuestion(request: CreateQuestionRequest) async throws -> Question {
        return try await networkAPI.request(
            QuestionEndpoint.postQuestion,
            parameters: request.toDictionary()
        )
    }
}