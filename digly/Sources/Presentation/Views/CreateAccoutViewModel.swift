import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class CreateAccountViewModel: ObservableObject {
    @Published var username: String = ""{ didSet {
        if username != oldValue {
            withAnimation (.mediumEaseInOut){
                isUsernameValid = false
                errorText = ""
            }
        }
    } }
    
    @Published var errorText: String = ""
    @Published var isExistingUser: Bool = false
    @Published var isUsernameValid: Bool = false
    
    @Published var isSelectingDigly: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var isAppleLoading: Bool = false
    @Published var selectedIndex :Int = 0
    
    private let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9_]{3,20}$")
    private let authUseCase: AuthUseCase
    private let accessToken: String
    private let refreshToken: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(accessToken: String, refreshToken: String, authUseCase: AuthUseCase = AuthUseCase()) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.authUseCase = authUseCase
    }
    
    func performSignUp(onSuccess: @escaping (SignUpResponse) -> Void) {
        Task {
            do {
                isLoading = true
                let selectedDiglyType = Digly.data[selectedIndex].diglyType
                let diglyType = selectedDiglyType
                
                let response = try await authUseCase.signUp(name: username, diglyType: diglyType, accessToken: accessToken)
                isLoading = false
                
                onSuccess(response)
                
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("회원가입"))
            }
        }
    }
    
    func handleLeftArrowPress(_ proxy:ScrollViewProxy){
        if selectedIndex>0 {
            withAnimation(.mediumEaseOut) {
                selectedIndex -= 1
                print(selectedIndex)
                proxy.scrollTo(selectedIndex, anchor: .center)
            }
        }
    }
    
    func handleRightArrowPress(_ proxy:ScrollViewProxy){
        if selectedIndex<Digly.data.count-1 {
            withAnimation(.mediumEaseOut) {
                selectedIndex += 1
                print(selectedIndex)
                proxy.scrollTo(selectedIndex, anchor: .center)
            }
        }
    }
    
    func handleSubmit(){
        if isUsernameValid {
            UserDefaults.standard.set(username, forKey: "lastLoggedInUsername")
            withAnimation(.mediumEaseInOut){ isSelectingDigly = true }
        } else {
            if username.count<2 {
                withAnimation(.mediumEaseInOut){
                    errorText = "*최소 2자 이상 입력해주세요."
                    return
                }
            } else if username.count>7  {
                withAnimation(.mediumEaseInOut){
                    errorText="*최대 7자까지 입력 가능합니다."
                    return
                }
            } else{
                // TODO: 서버로 부터 닉네임 중복여부 확인 후, 중복없을 시, usernameValid true로 전환
                isUsernameValid = true // 버튼 완료로 변경됨
            }
        }
    }
    
    func performAppleLogin(_ result: ASAuthorization) {
        isAppleLoading = true
        
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential else {
            print("Error: Unexpected credential type")
            isAppleLoading = false
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let idToken = String(data: identityTokenData, encoding: .utf8) else {
            print("Error: Unable to fetch identity token or authorization code")
            isAppleLoading = false
            return
        }
        print(idToken)
    }
    
    func checkUsername(){
        // TODO: 서버로 부터 닉네임 중복여부 확인
        isUsernameValid = true
    }
    
    func signUp() {
        isLoading = true
    }
    
}
