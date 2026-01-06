import SwiftUI

struct HomeTutorialOverlay: View {
    let onDismiss: () -> Void

    @State private var currentStep: Int = 0
    private let stepContents: [(title: String, description: String,index:Int)] = [
        ("디깅노트", "관람 기록을 남길 수 있는 공간이에요.\n작성 가이드를 활용해\n더 생생하게 기록을 남길 수 있어요.",1),
        ("티켓북", "티켓을 등록하고\n나의 기록을 한눈에 볼 수 있어요.",2)
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    Text("digly 서비스 소개")
                        .font(.body1)
                        .foregroundStyle(.opacityWhite500)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            PopupManager.shared.dismissPopup()
                            onDismiss()
                        }) {
                            Image("close")
                                .padding(24)
                        }
                    }
                }
                
                
                Spacer()
                Text(stepContents[currentStep].title)
                    .font(.heading1)
                    .foregroundColor(.opacityWhite900)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                
                Text(stepContents[currentStep].description)
                    .font(.body1)
                    .foregroundColor(.opacityWhite800)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)
                
                Image(stepContents[currentStep].title)
                
                Rectangle()
                    .fill(.common100)
                    .frame(width: 2, height: 56)
                Circle()
                    .fill(.common100)
                    .frame(width: 8)
                
                DGBottomTab(selectedTab: .constant(stepContents[currentStep].index))
                    .disabled(true)
            }
            .transition(.opacity)
            .id("step_\(currentStep)")
        }
        .overlay {
            HStack(spacing: 200) {
                Button(action: {
                    if currentStep > 0 {
                        currentStep -= 1
                    }
                }){
                    Image("arrow_left")
                        .renderingMode(.template)
                        .foregroundStyle(.common100)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .opacity(currentStep==0 ? 0 : 1)
                
                Button(action: {
                    if currentStep < stepContents.count - 1 {
                        currentStep += 1
                    }
                }){
                    Image("arrow_right")
                        .renderingMode(.template)
                        .foregroundStyle(.common100)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .opacity(currentStep==stepContents.count-1 ? 0 : 1)
            }
        }
        .animation(.mediumSpring, value: currentStep)
    }
}

#Preview {
    HomeTutorialOverlay(
        onDismiss: {}
    )
}
