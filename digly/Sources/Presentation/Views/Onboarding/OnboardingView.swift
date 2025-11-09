import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    @EnvironmentObject private var authRouter: AuthRouter
    
    var body: some View {
        DGScreen(horizontalPadding: 32, isLoading: viewModel.isLoading) {
            Spacer()
            
            Image("diglyText")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160)
                .padding(.bottom, 32)
            
            Text("문화생활의 여운\n일상에서 누릴 수 있는\n디깅라이프의 시작.")
                .fontStyle(.title2_)
                .foregroundStyle(.opacityCool400)
                .padding(.bottom, 24)
            
            Text("디글리에 오신\n당신을 환영합니다")
                .fontStyle(.title2_)
                .foregroundStyle(.neutral900)
                .padding(.bottom, 40)
            
            ZStack {
                Divider().background(.neutral700)
                
                Text("SNS 계정으로 로그인")
                    .foregroundColor(.neutral700)
                    .fontStyle(.caption1)
                    .padding(.horizontal, 16)
                    .background(.common100)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)
            
            HStack(spacing: 12){
                socialLoginButton(provider: "kakao")
                socialLoginButton(provider: "apple")
                socialLoginButton(provider: "naver")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 96)
        }
        .animation(.mediumSpring, value: viewModel.isPopupPresented)
        .overlay {
            Group {
                if viewModel.isPopupPresented {
                    ZStack {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                viewModel.isPopupPresented = false
                            }
                        
                        OnboardingAgreementPopup(
                            onContinue: {
                                viewModel.isPopupPresented = false
                                
                                if let accessToken = viewModel.tempAccessToken,
                                   let refreshToken = viewModel.tempRefreshToken {
                                    authRouter.push(to: .createAccount(accessToken: accessToken, refreshToken: refreshToken))
                                }
                            }
                        )
                    }
                }
            }
        }
    }
    
    private func socialLoginButton(provider: String) -> some View {
        Button(action: {
            viewModel.handleSocialLogin(provider)
        } ) {
            Image(provider)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 51,height: 51)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(12)
        }
        .disabled(viewModel.isLoading)
        .opacity(viewModel.isLoading ? 0.6 : 1.0)
    }
}

#Preview {
    OnboardingView()
}
