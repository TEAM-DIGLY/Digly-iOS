import Foundation

final class QuestionUseCase {
    private let questionRepository: QuestionRepositoryProtocol
    
    init(questionRepository: QuestionRepositoryProtocol) {
        self.questionRepository = questionRepository
    }
    
    func submitQuestion(email: String, title: String, content: String) async throws -> Question {
        let request = CreateQuestionRequest(email: email, title: title, content: content)
        return try await questionRepository.createQuestion(request: request)
    }
    
    func validateQuestionData(email: String, title: String, content: String) -> ValidationResult {
        var errors: [String] = []
        
        if !isValidEmail(email) {
            errors.append("올바른 이메일 형식이 아닙니다.")
        }
        
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("제목을 입력해주세요.")
        } else if title.count > 100 {
            errors.append("제목은 100자 이하로 입력해주세요.")
        }
        
        if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("내용을 입력해주세요.")
        } else if content.count > 1000 {
            errors.append("내용은 1000자 이하로 입력해주세요.")
        }
        
        return ValidationResult(isValid: errors.isEmpty, errors: errors)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct ValidationResult {
    let isValid: Bool
    let errors: [String]
}
