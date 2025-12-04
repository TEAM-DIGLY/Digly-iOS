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

    // 각 단계별 애니메이션 이름
    private let animationNames = ["onboarding_1", "onboarding_2", "onboarding_3"]

    // 각 애니메이션의 예상 재생 시간 (초)
    private let animationDurations: [Double] = [2.5, 2.5, 0]

    var body: some View {
        ZStack {
            Color.neutral900
                .ignoresSafeArea()

            // 애니메이션 뷰들
            ForEach(0..<3, id: \.self) { index in
                if currentStep == index {
                    LottieView(animation: .named(animationNames[index]))
                        .playbackMode(index < 2 ? .playing(.fromProgress(0, toProgress: 1.0, loopMode: .playOnce)) : .playing(.fromProgress(0, toProgress: 1.0, loopMode: .loop)))
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .onAppear {
                            if index < 2 {
                                // 애니메이션 완료 후 다음 단계로 전환
                                DispatchQueue.main.asyncAfter(deadline: .now() + animationDurations[index]) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        currentStep = index + 1
                                    }
                                }
                            }
                        }
                }
            }

            // 오버레이 텍스트
            VStack {
                Spacer()

                Text(stepTexts[currentStep])
                    .font(.heading2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .transition(.opacity)
                    .id("text_\(currentStep)")

                Spacer()
                    .frame(height: 200)
            }
            .animation(.easeInOut(duration: 0.3), value: currentStep)

            // 버튼 (마지막 단계에서만 표시)
            VStack {
                Spacer()

                if currentStep == 2 && isButtonPresent {
                    DGButton(text: "디글리 시작하기", type: .primary) {
                        AuthManager.shared.login(accessToken, refreshToken, signUpResponse.name, signUpResponse.memberType)
                    }
                    .padding(.bottom, 64)
                    .frame(width: 140)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.mediumSpring, value: isButtonPresent)
        }
        .onAppear {
            // 마지막 단계 도달 후 버튼 표시
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDurations[0] + animationDurations[1] + 0.8) {
                isButtonPresent = true
            }
        }
    }
}


#Preview {
    OnboardingConfirmView(signUpResponse: SignUpResult(id: 1, name: "asdf", memberType: .analyst), accessToken: "asf", refreshToken: "asdf")
}
