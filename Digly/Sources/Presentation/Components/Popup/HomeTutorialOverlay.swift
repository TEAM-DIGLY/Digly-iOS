import SwiftUI

struct HomeTutorialOverlay: View {
    @Binding var isPresented: Bool
    let onDismiss: () -> Void

    @State private var currentStep: Int = 0

    // 각 단계별 설명 텍스트
    private let stepContents: [(title: String, description: String)] = [
        ("디깅노트", "관람 기록을 남길 수 있는 공간이에요.\n작성 가이드를 활용해\n더 생생하게 기록을 남길 수 있어요."),
        ("티켓북", "티켓을 등록하고\n나의 기록을 한눈에 볼 수 있어요.")
    ]

    var body: some View {
        ZStack {
            // 반투명 배경
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    handleDismiss()
                }

            VStack {
                Spacer()

                // 현재 단계 콘텐츠
                VStack(spacing: 16) {
                    Text(stepContents[currentStep].title)
                        .font(.heading1)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(stepContents[currentStep].description)
                        .font(.body1)
                        .foregroundColor(.neutral300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .transition(.opacity)
                .id("step_\(currentStep)")

                Spacer()
                    .frame(height: 100)

                // 단계 인디케이터
                HStack(spacing: 8) {
                    ForEach(0..<stepContents.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentStep ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)

                // 다음/완료 버튼
                Button(action: {
                    if currentStep < stepContents.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep += 1
                        }
                    } else {
                        handleDismiss()
                    }
                }) {
                    Text(currentStep < stepContents.count - 1 ? "다음" : "시작하기")
                        .font(.headline1)
                        .foregroundColor(.neutral900)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }

    private func handleDismiss() {
        isPresented = false
        onDismiss()
    }
}

#Preview {
    HomeTutorialOverlay(
        isPresented: .constant(true),
        onDismiss: {}
    )
}
