import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 카카오 SDK 초기화
        KakaoSDK.initSDK(appKey: "YOUR_KAKAO_APP_KEY") // 실제 카카오 앱 키로 변경 필요
        
        // 네이버 로그인 설정
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = false
        instance?.isInAppOauthEnable = true
        instance?.setOnlyPortraitSupportInIphone(true)
        
        // 네이버 로그인 정보 설정 (실제 값으로 변경 필요)
        instance?.serviceUrlScheme = "com.digly.ios"
        instance?.consumerKey = "YOUR_NAVER_CLIENT_ID"
        instance?.consumerSecret = "YOUR_NAVER_CLIENT_SECRET"
        instance?.appName = "Digly"
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // 네이버 로그인 URL 처리
        if let naverHandled = NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options), naverHandled {
            return true
        }
        
        // 카카오 로그인 URL 처리
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}