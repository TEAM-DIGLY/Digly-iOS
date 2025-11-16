import SwiftUI
import Combine

enum InquiryFieldType {
    case email
    case title
    case content
}

@MainActor
class InquiryViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var isLoading: Bool = false

    private let questionUseCase: QuestionUseCase
    private var toastManager: ToastManager { ToastManager.shared }

    let titleMaxLength = 30
    let contentMaxLength = 1000

    var canSubmit: Bool {
        !email.isEmpty && !title.isEmpty && !content.isEmpty && !isLoading
    }

    init(questionUseCase: QuestionUseCase = QuestionUseCase(questionRepository: QuestionRepository())) {
        self.questionUseCase = questionUseCase
    }

    // MARK: - Actions
    func submitInquiry(onSuccess: @escaping () -> Void) {
        // Validate input
        let validationResult = questionUseCase.validateQuestionData(
            email: email,
            title: title,
            content: content
        )

        guard validationResult.isValid else {
            if let firstError = validationResult.errors.first {
                toastManager.show(.errorWithMessage(firstError))
            }
            return
        }

        // Submit question
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                _ = try await questionUseCase.submitQuestion(
                    email: email,
                    title: title,
                    content: content
                )

                toastManager.show(.success("문의가 등록되었습니다."))

                // Dismiss after showing toast
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                onSuccess()
            } catch {
                toastManager.show(.error(error))
            }
        }
    }
}
