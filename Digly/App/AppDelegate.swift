import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: "4ee0fdfa00eaf2dc90dd2ef13719e827")
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 로그인 설정
        instance?.isNaverAppOauthEnable = false
        instance?.isInAppOauthEnable = true
        instance?.setOnlyPortraitSupportInIphone(true)
        
        // 로그인 설정
        instance?.serviceUrlScheme = "com.teamDigly.digly"
        instance?.consumerKey = "KYrhYmtD1DwAEGFO7sK7"
        instance?.consumerSecret = "JKi6hWMPnP"
        instance?.appName = "Digly"
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let naverHandled = NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options), naverHandled {
            return true
        }
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
