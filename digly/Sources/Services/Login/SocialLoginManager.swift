//
//  SocialLoginManager.swift
//  Digly
//
//  Created by 윤동주 on 2/3/25.
//

import Foundation
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum SocialLoginError: Error {
    case appleLoginError(_ error: Error)
    case kakaoLoginError(_ error: Error)
    case kakaoLoginCancelled
}

class SocialLoginManager {
    
    // MARK: - Properties
    
    var appleLoginDelegate = AppleSignInDelegate()

    // MARK: - Functions
    
    /// Apple Login
    func getAppleIdentityToken() -> String {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleLoginDelegate
        controller.performRequests()
        
        return ""
    }
    
    /// Kakao Login
    @MainActor
    func getKakaoAccessToken() async -> String? {
        if UserApi.isKakaoTalkLoginAvailable() {
            return await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: nil)
                    } else {
                        dump(oauthToken)
                        continuation.resume(returning: oauthToken?.accessToken)
                    }
                }
            }
        } else {
            return await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: nil)
                    } else {
                        dump(oauthToken)
                        continuation.resume(returning: oauthToken?.accessToken)
                    }
                }
            }
        }
    }
    
    /// Naver Login
    func loginWithNaver() {
        
    }
}

// MARK: - Apple Login Delegate
class AppleSignInDelegate: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    
    // MARK: - Functions
    
    /// Apple Login 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("Success - Apple Login")
            
            // identityToken 가져오기
            // Data 형식의 identityToken을 String으로 변환
            let authCodeString = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
            let identityTokenString = String(data: appleIDCredential.identityToken!, encoding: .utf8)
            
        }

    }
    
    /// Apple Login 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(SocialLoginError.appleLoginError(error))
    }
}
