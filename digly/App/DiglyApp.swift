//
//  DiglyApp.swift
//  Digly
//
//  Created by 윤동주 on 1/26/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin

@main
struct DiglyApp: App {
    @State var naverLoginInstance: NaverThirdPartyLoginConnection?
    
    init() {
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        NaverLogin.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(naverLoginInstance: $naverLoginInstance)
                .onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    
                    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
                    _ = naverLoginInstance?.application(UIApplication.shared, open: url, options: [:])
                })
        }
    }
}
