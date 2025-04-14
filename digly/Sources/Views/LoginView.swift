//
//  LoginView.swift
//  Digly
//
//  Created by 윤동주 on 1/26/25.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin

struct LoginView: View {
    
    @State private var isPopupPresented: Bool = false
    @State private var socialLoginManager = SocialLoginManager()
    @State private var isNaverLogin: Bool = false
    @State private var viewModel = LoginViewModel()
    
    @Binding var naverLoginInstance: NaverThirdPartyLoginConnection?
    
    var body: some View {
        ZStack {
            if isNaverLogin {
                NaverLoginRepresentable()
            }
            
            VStack {
                Spacer()
                    .frame(height: 211)
                
                VStack(alignment: .leading) {
                    Image(.diglyText)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    Text("문화생활의 여운,\n일상에서 누릴 수 있는 \n디깅라이프의 시작")
                        .fontStyle(.title2_)
                        .foregroundStyle(.opacityCool55)
                        .padding(.top, 33)
                    
                    Text("디글리에 오신\n당신을 환영합니다")
                        .fontStyle(.title2_)
                        .foregroundStyle(.neutral5)
                        .padding(.top, 23)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 33)
                
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(.neutral75)
                        .padding(.horizontal, 32)
                    
                    Text("SNS 계정으로 로그인")
                        .fontStyle(.caption1)
                        .foregroundStyle(.neutral25)
                        .frame(width: 140)
                        .background(.white)
                }
                .padding(.top, 44)
                
                HStack(spacing: 11) {
                    SocialLoginButton(imageName: "kakao") {
                        Task {
                            do {
                                let result = try await viewModel.login(platformType: .kakao)
                                dump(result)
                            } catch {
                                print("Login failed with error: \(error)")
                            }
                        }
                    }
                    
                    SocialLoginButton(imageName: "apple") {
//                        socialLoginManager.getAppleIdentityToken()
                    }
                    
                    SocialLoginButton(imageName: "naver") {
                        isNaverLogin.toggle()
                    }
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            
    }
    
    func getNaverUserInfo() {
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        if !isValidAccessToken {
            return
        }

        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        guard let refreshToken = naverLoginInstance?.refreshToken else { return }

        let urlStr = "https://openapi.naver.com/v1/nid/me"

        
    }
}

// MARK: - Generic Social Login Button
struct SocialLoginButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 51, height: 51)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(12)
        }
    }
}

import UIKit
import NaverThirdPartyLogin
import SwiftUI

struct NaverLoginRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NaverLoginRepresentable>) -> NaverLoginViewController {
       let naverLoginViewController = NaverLoginViewController()

        return naverLoginViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

class NaverLoginViewController: UIViewController {

    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naverLoginInstance?.delegate = self
        self.naverLoginInstance?.requestThirdPartyLogin()
    }
}


extension NaverLoginViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성공시 메소드 (추가적인 API 통신을 진행하여 정보를 가져옴)
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
    }
    
    // 토큰을 재 갱신하는경우 메소드
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success RefreshToken")
    }
    
    // 로그아웃 (토큰 삭제) 완료시 메소드
    func oauth20ConnectionDidFinishDeleteToken() {
        print("Success logout")
        naverLoginInstance?.requestDeleteToken()
    }
    
    // 모든 에러관련한 메소드
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
        naverLoginInstance?.requestDeleteToken()
    }
}

//#Preview {
//    LoginView(naverLoginInstance:)
//}

struct NaverUserInfo {
    let name: String
    let email: String
    let id: String
}

extension NaverLoginViewController {
    func requestServerLogin(userInfo: NaverUserInfo) {
        
    }
}
