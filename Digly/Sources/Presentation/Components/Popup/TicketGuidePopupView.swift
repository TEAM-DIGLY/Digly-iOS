import SwiftUI

struct TicketGuidePopupView: View {
    @State private var currentStep: Int = 0
    let hidePopup: () -> Void
    
    private let guideSteps: [TicketGuideStep] = [
        TicketGuideStep(
            title: "티켓 정보 붙여넣기 가이드",
            description: "다른 앱에서 티켓 정보를 복사한 후\n붙여넣기 해주세요.",
            subDescription: "정확한 정보 추출을 위해 전체 텍스트를\n복사해주시기 바랍니다."
        ),
        TicketGuideStep(
            title: "정보 추출 완료",
            description: "붙여넣은 텍스트에서 필요한 정보를\n자동으로 추출했어요.",
            subDescription: "추출된 정보를 확인하고 수정이 필요한 경우\n직접 편집할 수 있어요."
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            contentSection
            bottomActionSection
        }
        .frame(width: 300, height: 465)
        .background(.neutral900, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.neutral100.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Components
extension TicketGuidePopupView {
    private var contentSection: some View {
        VStack(spacing: 0) {
            // Title and description
            VStack(spacing: 8) {
                Text(guideSteps[currentStep].title)
                    .fontStyle(.headline1)
                    .foregroundStyle(.neutral100)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 4) {
                    Text(guideSteps[currentStep].description)
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral300)
                        .multilineTextAlignment(.center)
                    
                    Text(guideSteps[currentStep].subDescription)
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral400)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 31)
            
            // Images
            HStack(spacing: 2) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.neutral800)
                    .frame(width: 133, height: 236)
                    .overlay {
                        // 실제 이미지로 교체 예정
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.neutral700, lineWidth: 1)
                    }
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(.neutral800)
                    .frame(width: 133, height: 236)
                    .overlay {
                        // 실제 이미지로 교체 예정
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.neutral700, lineWidth: 1)
                    }
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
        }
        .frame(height: 421)
    }
    
    private var bottomActionSection: some View {
        HStack(spacing: 0) {
            Button(action: {
                if currentStep > 0 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                } else {
                    hidePopup()
                }
            }) {
                Text(currentStep == 0 ? "닫기" : "이전")
                    .fontStyle(.body1)
                    .foregroundStyle(.neutral300)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            
            Rectangle()
                .fill(.neutral700)
                .frame(width: 0.5, height: 44)
            
            Button(action: {
                if currentStep < guideSteps.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep += 1
                    }
                } else {
                    hidePopup()
                }
            }) {
                Text(currentStep == guideSteps.count - 1 ? "완료" : "다음")
                    .fontStyle(.body1)
                    .foregroundStyle(.neutral200)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
        }
        .frame(height: 44)
        .background(.neutral900)
        .overlay(
            Rectangle()
                .fill(.neutral700)
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

// MARK: - Models
struct TicketGuideStep {
    let title: String
    let description: String
    let subDescription: String
}

#Preview {
    TicketGuidePopupView(hidePopup: {})
}
