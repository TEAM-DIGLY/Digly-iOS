import SwiftUI
import Lottie

struct OnboardingConfirmView: View {
    let signUpResponse: SignUpResult
    let accessToken: String
    let refreshToken: String
    @State private var currentStep: Int = 0 
    @State private var isButtonPresent = false
    @State private var isLoading = false

    // 각 단계별 오버레이 텍스트
    private let stepTexts = [
        "내가 즐기는 문화생활에\n푹 빠져 몰입하며",
        "남은 여운을 일상에서\n다양한 콘텐츠로 다시 만나보고",
        "다양한 시선을 가진 사람들과\n대화하는 즐거움을 누려보세요"
    ]

    private let animationNames = ["onboarding_1", "onboarding_2", "onboarding_3"]

    private var playMode: LottiePlaybackMode {
        switch currentStep {
        case 0: .playing(.fromProgress(0, toProgress: 1.0, loopMode: .loop))
        case 1: .playing(.fromProgress(0, toProgress: 1.0, loopMode: .loop))
        default: .playing(.fromProgress(0, toProgress: 1.0, loopMode: .loop))
        }
    }
    
    var body: some View {
        ZStack {
            Color.neutral900
                .ignoresSafeArea()
            
            ForEach(0..<3, id: \.self) { index in
                if currentStep == index {
                    LottieView(animation: .named(animationNames[index]))
                        .playbackMode(playMode)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                isButtonPresent = true
                            }
                        }
                }
            }
            
            VStack {
                Text(stepTexts[currentStep])
                    .font(.heading1)
                    .foregroundColor(.common100)
                    .multilineTextAlignment(.center)
                    .padding(.top, 120)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .id("text_\(currentStep)")
                
                Spacer()
            }
            
            if isButtonPresent {
                VStack {
                    Spacer()
                    DGButton(text: currentStep == 2 ? "디글리 시작하기" : "다음으로", type: currentStep == 2 ? .primary : .secondary) {
                        if currentStep == 2 {
                            AuthManager.shared.login(accessToken, refreshToken, signUpResponse.name, signUpResponse.memberType)
                        } else {
                            currentStep += 1
                            isButtonPresent = false
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 64)
                    .frame(width: 140)
                }
            }
        }
        .animation(.mediumSpring, value: currentStep)
        .animation(.mediumSpring, value: isButtonPresent)
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    OnboardingConfirmView(signUpResponse: SignUpResult(id: 1, name: "asdf", memberType: .analyst), accessToken: "asf", refreshToken: "asdf")
}
