import SwiftUI

struct TicketGuidePopupView: View {
    @State private var currentStep: Int = 0
    let hidePopup: () -> Void
    
    private let guideSteps: [TicketGuideStep] = [
        TicketGuideStep(
            title: "티켓 정보 붙여넣기 안내",
            description: "예매한 티켓의 상세정보를 모두 복사해주세요.",
            subDescription: "극 제목, 날짜와 시간, 장소, 좌석정보, 티켓 금액 정보 외에는 수집하지 않습니다."
        ),
        TicketGuideStep(
            title: "정보 추출 완료",
            description: "복사한 정보를 붙여넣고 ‘티켓 정보 인식하기'를 클릭합니다.",
            subDescription: ""
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
            Text(guideSteps[currentStep].title)
                .fontStyle(.body2)
                .foregroundStyle(.opacityWhite800)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
            Text("< Step \(currentStep+1) >")
                .fontStyle(.headline2)
                .foregroundStyle(.opacityWhite600)
            
            Text(guideSteps[currentStep].description)
                .fontStyle(.label2)
                .foregroundStyle(.opacityWhite850)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            Text(guideSteps[currentStep].subDescription)
                .fontStyle(.smallBold)
                .foregroundStyle(.error)
                .multilineTextAlignment(.center)
            
            Image("step_\(currentStep + 1)")
        }
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
