import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published  var isPopupPresented: Bool = false
    
    @Published var isFirstChecked = false
    @Published var isSecondChecked = false
    @Published var isThirdChecked = false
    
    private let authUseCase: AuthUseCase
    private var tempAccessToken: String?
    private var tempRefreshToken: String?
    
    init(authUseCase: AuthUseCase = AuthUseCase()) {
        self.authUseCase = authUseCase
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func submit(){
    }
    
    // MARK: - 소셜로그인 메서드들
    func performKakaoLogin() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let token = try await KakaoLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .kakao, socialToken: token)
            
            print("카카오 로그인 성공: \(response)")
            
            if response.name == nil {
                tempAccessToken = response.accessToken
                tempRefreshToken = response.refreshToken
                isPopupPresented = true
            } else {
                AuthManager.shared.login(response.accessToken, response.refreshToken, response.name ?? "")
            }
            
        } catch {
            errorMessage = "카카오 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
            print("카카오 로그인 실패: \(error)")
        }
        
        isLoading = false
    }
    
    func performNaverLogin() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let token = try await NaverLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .naver, socialToken: token)
            
            print("네이버 로그인 성공: \(response)")
            
            if response.name == nil {
                tempAccessToken = response.accessToken
                tempRefreshToken = response.refreshToken
                isPopupPresented = true
            } else {
                AuthManager.shared.login(response.accessToken, response.refreshToken, response.name ?? "")
            }
            
        } catch {
            errorMessage = "네이버 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
            print("네이버 로그인 실패: \(error)")
        }
        
        isLoading = false
    }
    
    func performAppleLogin() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let identityToken = try await AppleLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .apple, socialToken: identityToken)
            
            print("애플 로그인 성공: \(response)")
            
            if response.name == nil {
                tempAccessToken = response.accessToken
                tempRefreshToken = response.refreshToken
                isPopupPresented = true
            } else {
                AuthManager.shared.login(response.accessToken, response.refreshToken, response.name ?? "")
            }
            
        } catch {
            errorMessage = "애플 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
            print("애플 로그인 실패: \(error)")
        }
        
        isLoading = false
    }
    
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
    
    func signUp() {
        isLoading = true
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
    
    func getAccessToken() -> String? {
        return tempAccessToken
    }
    
    func getRefreshToken() -> String? {
        return tempRefreshToken
    }
    
    func getTokens() -> (accessToken: String?, refreshToken: String?) {
        return (tempAccessToken, tempRefreshToken)
    }
}
