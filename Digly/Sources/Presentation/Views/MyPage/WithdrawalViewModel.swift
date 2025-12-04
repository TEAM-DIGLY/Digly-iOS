import SwiftUI

@MainActor
class WithdrawalViewModel: ObservableObject {
    @Published var isDropdownExpanded: Bool = false
    @Published var selectedReason: WithdrawalReason? = nil
    @Published var customReasonText: String = ""
    @Published var isLoading: Bool = false

    private let memberUseCase: MemberUseCase
    private var authManager: AuthManager { AuthManager.shared }
    private var toastManager: ToastManager { ToastManager.shared }

    var nickname: String {
        authManager.nickname
    }

    var memberSinceDays: Int {
        // Calculate days since registration
        // For now, return a placeholder value
        // TODO: Get actual registration date from AuthManager or API
        return 30
    }

    var isWithdrawButtonEnabled: Bool {
        guard let reason = selectedReason else { return false }

        if reason == .other {
            return !customReasonText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   customReasonText.count <= 100
        }

        return true
    }

    init(memberUseCase: MemberUseCase = MemberUseCase()) {
        self.memberUseCase = memberUseCase
    }

    // MARK: - Actions
    func toggleDropdown() {
        withAnimation(.mediumSpring) {
            isDropdownExpanded.toggle()
        }
    }

    func selectReason(_ reason: WithdrawalReason) {
        selectedReason = reason
        customReasonText = ""

        withAnimation(.mediumSpring) {
            isDropdownExpanded = false
        }
    }

    func performWithdrawal() {
        guard let reason = selectedReason else {
            toastManager.show(.errorWithMessage("탈퇴 사유를 선택해주세요."))
            return
        }

        let withdrawalReason: String
        if reason == .other {
            withdrawalReason = customReasonText.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            withdrawalReason = reason.rawValue
        }

        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                try await memberUseCase.withdrawMember(reason: withdrawalReason)
                toastManager.show(.success("회원 탈퇴가 완료되었습니다."), isDelayNeeded: true)
                authManager.logout()
            } catch {
                toastManager.show(.error(error))
            }
        }
    }
}
