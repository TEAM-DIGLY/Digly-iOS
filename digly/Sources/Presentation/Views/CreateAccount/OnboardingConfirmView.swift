import SwiftUI
import Lottie

struct OnboardingConfirmView: View {
    let signUpResponse: SignUpResult
    let accessToken: String
    let refreshToken: String
    @State private var isButtonPresent = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.neutral900
                .ignoresSafeArea()
            
            LottieView(animation: .named("onboarding_3"))
                .playbackMode(.playing(.fromProgress(0, toProgress: 1.0, loopMode: .loop)))
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay(alignment: .bottom) {
                    if isButtonPresent {
                        DGButton(text: "디글리 시작하기", type: .primary) {
                            AuthManager.shared.login(accessToken, refreshToken, signUpResponse.name, signUpResponse.memberType)
                        }
                        .padding(.bottom, 64)
                        .frame(width: 140)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.mediumSpring, value: isButtonPresent)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        isButtonPresent = true
                    }
                }
        }
    }
}


#Preview {
    OnboardingConfirmView(signUpResponse: SignUpResult(id: 1, name: "asdf", memberType: .analyst), accessToken: "asf", refreshToken: "asdf")
}
