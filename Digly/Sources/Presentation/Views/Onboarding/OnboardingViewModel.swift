import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    @Published  var isPopupPresented: Bool = false
    
    @Published var isFirstChecked = false
    @Published var isSecondChecked = false
    @Published var isThirdChecked = false
    
    private let authUseCase: AuthUseCase
    var tempAccessToken: String?
    var tempRefreshToken: String?
    
    init(authUseCase: AuthUseCase = AuthUseCase()) {
        self.authUseCase = authUseCase
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func handleSocialLogin(_ provider: String) {
        Task {
            switch provider.lowercased() {
            case "kakao":
                await performKakaoLogin()
            case "naver":
                await performNaverLogin()
            case "apple":
                await performAppleLogin()
            default:
                print("지원하지 않는 소셜 로그인 플랫폼: \(provider)")
            }
        }
    }
    
    func handleLoginSuccess(_ response: SignInResponse) {
        if let name = response.name, let diglyType = response.memberType {
            AuthManager.shared.login(response.accessToken, response.refreshToken, name, diglyType)
        } else {
            tempAccessToken = response.accessToken
            tempRefreshToken = response.refreshToken
            isPopupPresented = true
        }
    }
    
    // MARK: - 소셜로그인 메서드들
    func performKakaoLogin() async {
        do {
            isLoading = true
            let token = try await KakaoLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .kakao, socialToken: token)
            isLoading = false
            
            handleLoginSuccess(response)
        } catch {
            isLoading = false
            ToastManager.shared.show(.errorStringWithTask("카카오 로그인"))
        }
    }
    
    func performNaverLogin() async {
        do {
            isLoading = true
            let token = try await NaverLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .naver, socialToken: token)
            isLoading = false
            
            handleLoginSuccess(response)
        } catch {
            isLoading = false
            ToastManager.shared.show(.errorStringWithTask("네이버 로그인"))
        }
    }
    
    func performAppleLogin() async {
        do {
            isLoading = true
            let token = try await AppleLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .apple, socialToken: token)
            isLoading = false
            
            handleLoginSuccess(response)
        } catch {
            isLoading = false
            ToastManager.shared.show(.errorStringWithTask("애플 로그인"))
        }
    }
    
    var isAllChecked: Bool {
        isFirstChecked &&
        isSecondChecked &&
        isThirdChecked
    }
    
    var isContinueButtonDisabled: Bool {
        !(isFirstChecked && isSecondChecked) ||
        isLoading
    }
    
    func toggleAllChecks() {
        let newValue = !isAllChecked
        withAnimation(.fastEaseOut) {
            isFirstChecked = newValue
            isSecondChecked = newValue
            isThirdChecked = newValue
        }
    }
}
