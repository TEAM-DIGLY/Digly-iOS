import SwiftUI
import Combine

@MainActor
class ProfileSettingViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var currentCharacterIndex: Int = 0
    @Published var isLoading: Bool = false

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
        // Update nickname
        authManager.updateNickname(nickname)

        // Update character
        authManager.updateDiglyType(characters[currentCharacterIndex].diglyType)

        onSuccess()
    }

    // MARK: - Withdrawal
    func showWithdrawalConfirmation() {
        popupManager.show(.deleteAccountWarning(onClick: { [weak self] in
            self?.performWithdrawal()
        }))
    }

    func performWithdrawal() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                // Call withdrawal API with reason
                try await memberUseCase.withdrawMember(reason: "사용자 요청")

                // Show success message
                toastManager.show(.success("회원 탈퇴가 완료되었습니다."))

                // Logout after delay
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                authManager.logout()
            } catch {
                toastManager.show(.error(error))
            }
        }
    }

    // MARK: - Helper Methods
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
}
