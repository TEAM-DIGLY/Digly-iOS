//
//  OnboardingView.swift
//  digly
//
//  Created by 김 형석 on 10/14/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    @State private var isPopupPresented:Bool = false
    @State private var isTotalChecked:Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack(spacing:52){
                    VStack(alignment:.leading,spacing:24){
                        Image("icon-text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 160)
                            .padding(.bottom,8)
                        
                        Text("문화생활의 여운\n일상에서 누릴 수 있는\n디깅라이프의 시작.")
                            .fontStyle(.title2_)
                            .foregroundStyle(.opacityCool55)
                        
                        Text("디글리에 오신\n당신을 환영합니다")
                            .fontStyle(.title2_)
                            .foregroundStyle(.neutral5)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Spacer()
                    
                    HStack(spacing:12){
                        socialLoginButton(provider: "apple")
                        socialLoginButton(provider: "X")
                        socialLoginButton(provider: "kakao")
                    }
                }
                .padding(.horizontal,32)
                .padding(.top,160)
                .padding(.bottom,64)// TODO: 화면 비율 대응 필요
                
                if isPopupPresented {
                    ZStack{
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        OnboardingDetail(viewModel: viewModel,isShowing: $isPopupPresented)
                    }
                }
            }
        }
    }
    
    private func socialLoginButton(provider: String) -> some View {
        Button(action: {
//            viewModel.handleSocialLogin(provider)
            withAnimation(.mediumEaseOut){
                isPopupPresented = true
            }
        } ) {
            Image(provider)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:51,height: 51)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(12)
        }
    }
}

#Preview {
    OnboardingView()
}
