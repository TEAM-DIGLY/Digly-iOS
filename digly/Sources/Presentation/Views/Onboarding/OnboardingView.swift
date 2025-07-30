import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    @State private var isPopupPresented:Bool = false
    @State private var isTotalChecked:Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing:0){
                    VStack(alignment:.leading,spacing:24){
                        Image("diglyText")
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
                    .padding(.bottom,52)
                    
                    HStack(spacing:18) {
                        VStack { Divider().frame(maxWidth: 86).background(.neutral25) }
                        
                        Text("SNS 계정으로 로그인")
                            .foregroundColor(.neutral25)
                            .fontStyle(.caption1)
                        
                        VStack { Divider().frame(maxWidth: 86).background(.neutral25) }
                    }
                    .padding(.bottom,16)
                    
                    HStack(spacing:12){
                        socialLoginButton(provider: "kakao")
                        socialLoginButton(provider: "apple")
                        socialLoginButton(provider: "naver")
                    }
                    .padding(.bottom, 16)
                    
                    // 로딩 인디케이터
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.bottom, 16)
                    }
                    
                    // 에러 메시지
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .fontStyle(.caption1)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.horizontal,32)
                .padding(.top,160)
                .padding(.bottom,64)
                
                if isPopupPresented {
                    OnboardingDetailView(isPresented: $isPopupPresented)
                }
            }
        }
    }
    
    private func socialLoginButton(provider: String) -> some View {
        Button(action: {
            // 소셜로그인 실행
            viewModel.handleSocialLogin(provider)
        } ) {
            Image(provider)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:51,height: 51)
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
