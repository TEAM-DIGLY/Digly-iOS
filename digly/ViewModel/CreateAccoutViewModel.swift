//
//  CreateAccoutViewModel.swift
//  digly
//
//  Created by Neoself on 11/3/24.
//

import Foundation
import Combine
import AuthenticationServices
import GoogleSignIn
import SwiftUI

class CreateAccoutViewModel: ObservableObject {
    @ObservedObject private var appState: AppState
    
    @Published var currentToast: ToastType?
    @Published var username: String = ""{didSet{
        if username != oldValue {
            withAnimation (.mediumEaseInOut){
                isUsernameValid = false
                errorText = ""
            }
        }
    }}
    
    @Published var errorText: String = ""
    @Published var isExistingUser: Bool = false
    @Published var isUsernameValid: Bool = false
    @Published var isSelectingDigly: Bool = false
    
    @Published var isLoading: Bool = false
    
    @Published var selectedIndex :Int = 0
    
    private let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9_]{3,20}$")
    
    init(appState: AppState = .shared) {
        self.appState = appState
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func handleDone(){
        appState.isLoggedIn = true
    }
    
    // TODO: 연타할때 애니메이션 중간에 끊기는 문제 발생. 해결 필요
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
        if selectedIndex<DiglyType.data.count-1 {
            withAnimation(.mediumEaseOut) {
                selectedIndex += 1
                print(selectedIndex)
                proxy.scrollTo(selectedIndex, anchor: .center)
            }
        }
    }
    
    func handleSubmit(){
        if isUsernameValid {
            withAnimation(.mediumEaseInOut){
                UserDefaults.standard.set(username, forKey: "lastLoggedInUsername")
                isSelectingDigly = true
            }
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
    
    func checkUsername(){
        // TODO: 서버로 부터 닉네임 중복여부 확인
        isUsernameValid = true
    }
    
    func signUp() {
        isLoading = true
    }
    
}
