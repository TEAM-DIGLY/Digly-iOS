//
//  OnboardingViewModel.swift
//  digly
//
//  Created by Neoself on 11/2/24.
//

import Foundation
import Combine
import AuthenticationServices
import GoogleSignIn
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @ObservedObject private var appState: AppState
    @Published var path = NavigationPath()
    
    @Published var currentToast: ToastType?
    @Published var isLoading: Bool = false
    
    @Published var isFirstChecked = false
    @Published var isSecondChecked = false
    @Published var isThirdChecked = false
    
    private let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9_]{3,20}$")
    
    
    init(appState: AppState = .shared) {
        self.appState = appState
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func submit(){
    }
    
    func handleSocialLogin(_ provider:String){
        print("provider:\(provider)")
        path.append(Route.createAccount)
    }
    
    func signUp() {
        isLoading = true
    }
    
    var isAllChecked:Bool {
        isFirstChecked &&
        isSecondChecked &&
        isThirdChecked
    }
    
    var isContinueButtonDisabled:Bool {
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
    
    //MARK: - 소셜로그인 관련 메서드
    // 웹을 통해 Google 소셜로그인 진행
    func startGoogleSignIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            self.currentToast = .error("구글 로그인이 잠시 안되고 있어요. 나중에 다시 시도해주세요.")
            return
        }
        
        isLoading = true
        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
//            DispatchQueue.main.async {
//                self?.isSocialLoading = false
//                
//                if let error = error {
//                    print(error.localizedDescription)
//                    self?.handleGoogleSignInError(error)
//                } else if let signInResult = signInResult {
//                    print(signInResult.description)
//                    self?.handleGoogleSignInSuccess(signInResult)
//                }
//            }
//        }
    }
    
    private func handleGoogleSignInError(_ error: Error) {
        if let error = error as? GIDSignInError {
            switch error.code {
            case .canceled:
                print("구글 로그인 도중에 취소됨")
            case .hasNoAuthInKeychain:
                self.currentToast = .googleError
            default:
                self.currentToast = .googleError
            }
        } else {
//            self.currentToast = .googleError
            
        }
    }
    
    private func handleGoogleSignInSuccess(_ signInResult: GIDSignInResult) {
        if let idToken = signInResult.user.idToken?.tokenString {
            performGoogleLogin(with: idToken)
        } else {
            self.currentToast = .googleError
        }
    }
    
    private func performGoogleLogin(with idToken: String) {
        isLoading = true
//        authService.socialLogin(idToken: idToken, provider: "google")
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isSocialLoading = false
//                if case .failure(let error) = completion {
//                    self?.currentToast = .error(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] loginResponse in
//                self?.handleSuccessfulLogin(loginResponse: loginResponse)
//            }
//            .store(in: &cancellables)
    }
    
    func performAppleLogin(_ result: ASAuthorization) {
        isLoading = true
        
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential else {
            print("Error: Unexpected credential type")
            isLoading = false
            return
        }
        
        guard let identityTokenData = appleIDCredential.identityToken,
              let idToken = String(data: identityTokenData, encoding: .utf8) else {
            print("Error: Unable to fetch identity token or authorization code")
            isLoading = false
            return
        }
        
//        authService.socialLogin(idToken: idToken, provider: "apple")
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isSocialLoading = false
//                if case .failure(let error) = completion {
//                    self?.currentToast = .error(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] loginResponse in
//                self?.handleSuccessfulLogin(loginResponse: loginResponse)
//            }
//            .store(in: &cancellables)
    }
    
    private func handleSuccessfulLogin(loginResponse: LoginResponse) {
        do {
            try KeychainManager.shared.save(token: loginResponse.token, forKey: "accessToken")
            print("lastLoggedInEmail changed into \(loginResponse.user.username)")
//            UserDefaults.standard.set(loginResponse.user.email, forKey: "lastLoggedInEmail")
            appState.isLoggedIn = true
        } catch {
            currentToast = .error(error.localizedDescription)
        }
    }
}
