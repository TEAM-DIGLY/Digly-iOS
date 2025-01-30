//
//  LoginView.swift
//  Digly
//
//  Created by 윤동주 on 1/26/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var isPopupPresented: Bool = false
    
    var body: some View {
        VStack() {
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
                SocialLoginButton(
                    imageName: "kakao",
                    isPopupPresented: $isPopupPresented
                )
                
                SocialLoginButton(
                    imageName: "apple",
                    isPopupPresented: $isPopupPresented
                )
                
                SocialLoginButton(
                    imageName: "naver",
                    isPopupPresented: $isPopupPresented
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - View Extension
extension LoginView {
    func SocialLoginButton(
        imageName: String,
        isPopupPresented: Binding<Bool>
    ) -> some View {
        Button {
            withAnimation(.mediumEaseOut) {
                isPopupPresented.wrappedValue = true
            }
        } label: {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 51, height: 51)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(12)
        }
    }
}

#Preview {
    LoginView()
}
