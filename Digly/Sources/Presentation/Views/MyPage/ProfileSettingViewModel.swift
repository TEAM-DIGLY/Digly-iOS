import SwiftUI
import Combine

@MainActor
class ProfileSettingViewModel: ObservableObject {
    @Published var nickname: String = "" {
        didSet {
            if oldValue != nickname {
                validateNickname()
            }
        }
    }
    @Published var nicknameErrorText: String = ""
    @Published var isNicknameValid: Bool = false
    
    @Published var currentCharacterIndex: Int = 0
    @Published var isEditMode: Bool = false
    @Published var isLoading: Bool = false

    private let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\p{L}\\p{N}\\p{P}\\p{S}]{2,7}$")
    private let memberUseCase: MemberUseCase
    private var authManager: AuthManager { AuthManager.shared }
    private var popupManager: PopupManager { PopupManager.shared }
    private var toastManager: ToastManager { ToastManager.shared }

    let characters = Digly.data

    init(memberUseCase: MemberUseCase = MemberUseCase()) {
        self.memberUseCase = memberUseCase
    }

    // MARK: - Lifecycle
    func onAppear() {
        nickname = authManager.nickname
        currentCharacterIndex = characters.firstIndex { $0.diglyType == authManager.diglyType } ?? 0
        validateNickname()
    }

    // MARK: - Character Selection
    func selectPreviousCharacter() {
        currentCharacterIndex = (currentCharacterIndex - 1 + characters.count) % characters.count
    }

    func selectNextCharacter() {
        currentCharacterIndex = (currentCharacterIndex + 1) % characters.count
    }

    // MARK: - Save Profile
    func saveProfile(onSuccess: @escaping () -> Void) {
        guard isNicknameValid else {
            toastManager.show(.errorWithMessage("닉네임 형식을 확인해주세요."))
            return
        }

        Task {
            do {
                isLoading = true
                let diglyType = characters[currentCharacterIndex].diglyType
                let result = try await memberUseCase.updateMemberProfile(
                    name: nickname,
                    memberType: diglyType
                )
                
                // Update local caches after API success
                authManager.updateNickname(result.name)
                authManager.updateDiglyType(result.memberType)
                isEditMode = false
                
                onSuccess()
                ToastManager.shared.show(.success("프로필 수정이 완료되었습니다"))
            } catch {
                toastManager.show(.error(error))
            }
            isLoading = false
        }
    }

    // MARK: - Helper Methods
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
    
    // MARK: - Validation
    private func validateNickname() {
        guard !nickname.isEmpty else {
            nicknameErrorText = ""
            isNicknameValid = false
            return
        }

        if nicknamePredicate.evaluate(with: nickname) {
            nicknameErrorText = ""
            isNicknameValid = true
        } else {
            nicknameErrorText = "*닉네임은 2~7자의 한글/영문/숫자/특수기호로 입력해주세요."
            isNicknameValid = false
        }
    }
}
