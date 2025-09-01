import Foundation
import SwiftUI
import AuthenticationServices

// MARK: - 카카오 로그인 매니저
import KakaoSDKUser
import KakaoSDKCommon

final class KakaoLoginManager {
    static let shared = KakaoLoginManager()
    private init() {}
    
    func login() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    // 사용자 취소 감지 (cherrydan-iOS 패턴)
                    if let sdkError = error as? SdkError,
                       case .ClientFailed(let reason, _) = sdkError,
                       reason == .Cancelled {
                        continuation.resume(throwing: SocialLoginError.userCancelled)
                    } else {
                        continuation.resume(throwing: SocialLoginError.networkError)
                    }
                } else if let token = oauthToken?.accessToken {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: SocialLoginError.tokenNotFound)
                }
            }
        }
    }
}

// MARK: - 네이버 로그인 매니저
import NaverThirdPartyLogin

final class NaverLoginManager: NSObject, ObservableObject {
    static let shared = NaverLoginManager()
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    @Published var isLoading = false
    private var continuation: CheckedContinuation<String, Error>?
    
    override init() {
        super.init()
        setupNaverLogin()
    }
    
    private func setupNaverLogin() {
        instance?.delegate = self
    }
    
    func login() async throws -> String {
        isLoading = true
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            instance?.requestThirdPartyLogin()
        }
    }
}

extension NaverLoginManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃 완료")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        isLoading = false
        
        // 네이버 로그인 취소/오류 상세 처리
        if let nsError = error as NSError? {
            if nsError.code == -1002 || nsError.localizedDescription.contains("cancelled") {
                continuation?.resume(throwing: SocialLoginError.userCancelled)
            } else {
                continuation?.resume(throwing: SocialLoginError.networkError)
            }
        } else {
            continuation?.resume(throwing: SocialLoginError.unknownError)
        }
        continuation = nil
    }
    
    private func handleNaverLoginSuccess() {
        guard let accessToken = instance?.accessToken else {
            isLoading = false
            continuation?.resume(throwing: SocialLoginError.tokenNotFound)
            continuation = nil
            return
        }
        
        isLoading = false
        continuation?.resume(returning: accessToken)
        continuation = nil
    }
}

// MARK: - 애플 로그인 매니저
final class AppleLoginManager: NSObject, ObservableObject {
    static let shared = AppleLoginManager()
    
    private var continuation: CheckedContinuation<String, Error>?
    
    func login() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: SocialLoginError.tokenNotFound)
            continuation = nil
            return
        }
        
        continuation?.resume(returning: identityToken)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Apple 로그인 사용자 취소 감지
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                continuation?.resume(throwing: SocialLoginError.userCancelled)
            case .failed:
                continuation?.resume(throwing: SocialLoginError.networkError)
            case .invalidResponse:
                continuation?.resume(throwing: SocialLoginError.tokenNotFound)
            case .notHandled:
                continuation?.resume(throwing: SocialLoginError.unknownError)
            case .unknown:
                continuation?.resume(throwing: SocialLoginError.unknownError)
            @unknown default:
                continuation?.resume(throwing: SocialLoginError.unknownError)
            }
        } else {
            continuation?.resume(throwing: SocialLoginError.unknownError)
        }
        continuation = nil
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}

// MARK: - 소셜로그인 에러
enum SocialLoginError: Error, LocalizedError {
    case tokenNotFound
    case userCancelled
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .tokenNotFound:
            return "토큰을 가져올 수 없습니다."
        case .userCancelled:
            return "사용자가 로그인을 취소했습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}