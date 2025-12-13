import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isPopupPresented: Bool = false
    
    private let authUseCase: AuthUseCase
    var tempAccessToken: String?
    var tempRefreshToken: String?
    var tempName: String? // 회원가입 화면으로 전환 될 때, 해당 값 유무를 통해 이름 입력 섹션 스킵여부 판단
    
    init(authUseCase: AuthUseCase = AuthUseCase()) {
        self.authUseCase = authUseCase
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
    
    func handleLoginSuccess(_ response: SignInResult, _ platform: PlatformType) {
        /// 기존에 로그인한 이력이 남아있을 경우, memberType이 존재하기 때문에 이를 바탕으로 바로 로그인 진행
        if let diglyType = response.memberType {
            AuthManager.shared.login(response.accessToken, response.refreshToken, response.name ?? "회원" , diglyType)
        } else {
            if let name = response.name { /// 회원가입을 시도하는 경우이나, 해당 플랫폼으로부터 이름을 수집할 수 있어 이름을 전달받는 경우
                tempName = name
            }
            
            /// 회원가입을 시도하는 경우이나, 아무런 정보를 얻을 수 없는 경우
            tempAccessToken = response.accessToken
            tempRefreshToken = response.refreshToken
            isLoading = false
            
            isPopupPresented = true
        }
    }
    
    
    // MARK: - 소셜로그인 메서드들
    func performKakaoLogin() async {
        do {
            isLoading = true
            let token = try await KakaoLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .kakao, socialToken: token)
            handleLoginSuccess(response, .kakao)
        } catch {
            isLoading = false
            handleSocialLoginError(error, platform: "카카오")
        }
    }
    
    func performNaverLogin() async {
        do {
            isLoading = true
            let token = try await NaverLoginManager.shared.login()
            let response = try await authUseCase.signIn(platform: .naver, socialToken: token)
            handleLoginSuccess(response, .naver)
        } catch {
            isLoading = false
            handleSocialLoginError(error, platform: "네이버")
        }
    }
    
    func performAppleLogin() async {
        do {
            isLoading = true
            let result = try await AppleLoginManager.shared.login()
            if let fullName = result.fullName { /// 최초 승인 시에만 제공되는 이름을 회원가입으로 넘긴다
                tempName = fullName
            }
            let response = try await authUseCase.signIn(platform: .apple, socialToken: result.token)
            handleLoginSuccess(response, .apple)
        } catch {
            isLoading = false
            handleSocialLoginError(error, platform: "애플")
        }
    }
    
    private func handleSocialLoginError(_ error: Error, platform: String) {
        if let socialError = error as? SocialLoginError {
            switch socialError {
            case .userCancelled:
                return
            case .tokenNotFound:
                ToastManager.shared.show(.errorWithMessage("\(platform) 인증 정보를 가져올 수 없습니다."))
            case .networkError:
                ToastManager.shared.show(.errorWithMessage("네트워크 오류가 발생했습니다. 다시 시도해주세요."))
            case .unknownError:
                ToastManager.shared.show(.errorWithMessage("알 수 없는 오류가 발생했습니다."))
            }
        } else {
            ToastManager.shared.show(.errorStringWithTask("\(platform) 로그인"))
        }
    }
    
}
