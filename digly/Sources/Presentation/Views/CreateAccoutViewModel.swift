import Foundation
import Combine
import AuthenticationServices
import SwiftUI

@MainActor
class CreateAccountViewModel: ObservableObject {
    @Published var username: String = ""{
        didSet {
            if username != oldValue {
                withAnimation(.mediumEaseInOut) {
                    updateUsernameValidation()
                }
            }
        }
    }
    
    @Published var errorText: String = ""
    @Published var isExistingUser: Bool = false
    @Published var isUsernameValid: Bool = false
    
    @Published var isSelectingDigly: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var isAppleLoading: Bool = false
    @Published var selectedIndex :Int = 0
    
    private let usernameAllowedRegex = "^[\\p{L}\\p{N}\\p{P}\\p{S}]+$"
    private let authUseCase: AuthUseCase
    private let memberUseCase: MemberUseCase
    private let accessToken: String
    private let refreshToken: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        accessToken: String,
        refreshToken: String,
        name: String?,
        authUseCase: AuthUseCase = AuthUseCase(),
        memberUseCase: MemberUseCase = MemberUseCase()
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        self.authUseCase = authUseCase
        self.memberUseCase = memberUseCase
        
        if let name {
            self.username = name
            self.isSelectingDigly = true
        }
    }
    
    func performSignUp(onSuccess: @escaping (SignUpResult) -> Void) {
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
        updateUsernameValidation()
        if isUsernameValid {
            UserDefaults.standard.set(username, forKey: "lastLoggedInUsername")
            withAnimation(.mediumEaseInOut){ isSelectingDigly = true }
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
        Task {
            do {
                isLoading = true
                try await memberUseCase.checkDuplicateNameOnServer(username)
                isUsernameValid = true
                errorText = ""
            } catch let error as APIError {
                isUsernameValid = false
                errorText = error.localizedDescription
            } catch {
                isUsernameValid = false
                errorText = "닉네임 확인 중 오류가 발생했습니다."
            }
            isLoading = false
        }
    }
    
    func signUp() {
        isLoading = true
    }

    private func updateUsernameValidation() {
        if username.isEmpty {
            isUsernameValid = false
            errorText = ""
            return
        }

        if username.count < 2 {
            isUsernameValid = false
            errorText = "*최소 2자 이상 입력해주세요."
            return
        }

        if username.count > 7 {
            isUsernameValid = false
            errorText = "*최대 7자까지 입력 가능합니다."
            return
        }

        let isAllowed = username.range(
            of: usernameAllowedRegex,
            options: .regularExpression
        ) != nil

        if !isAllowed {
            isUsernameValid = false
            errorText = "*한글, 영문, 숫자, 특수기호, 이모티콘만 사용할 수 있어요."
            return
        }

        isUsernameValid = true
        errorText = ""
    }
    
}
