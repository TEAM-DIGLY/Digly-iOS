import SwiftUI
import Lottie

struct OnboardingConfirmView: View {
    let signUpResponse: SignUpResult
    let accessToken: String
    let refreshToken: String
    @State private var isButtonPresent = true
    @State private var isLoading = false
    
    var body: some View {
        LottieView(animation: .named("onboarding_2"))
            .playbackMode(.playing(.fromProgress(0, toProgress: 0.2, loopMode: .loop)))

            .overlay(alignment: .bottom) {
                if isButtonPresent {
                    DGButton(text: "디글리 시작하기", type: .primaryDark) {
                        AuthManager.shared.login(accessToken, refreshToken, signUpResponse.name, signUpResponse.memberType)
                    }
                    .padding(.bottom, 64)
                    .frame(width: 140)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.mediumSpring, value: isButtonPresent)
            .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    OnboardingConfirmView(signUpResponse: SignUpResult(id: 1, name: "asdf", memberType: .analyst), accessToken: "asf", refreshToken: "asdf")
}
