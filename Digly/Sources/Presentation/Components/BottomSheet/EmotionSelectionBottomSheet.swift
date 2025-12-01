import SwiftUI

struct EmotionSelectionBottomSheet: View {
    let updateEmotion: ([Emotion]) -> Void
    
    @Environment(\.dismiss) private var dismiss

    @State private var selectedEmotions: [Emotion]
    @State private var isLoading: Bool = false

    private let ticketUseCase: TicketUseCase

    init(
        currentEmotions: [Emotion],
        updateEmotion: @escaping ([Emotion]) -> Void,
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.updateEmotion = updateEmotion
        self.ticketUseCase = ticketUseCase
        selectedEmotions = currentEmotions
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            EmotionBackgroundGradient(selectedEmotions: selectedEmotions, size: 424, opacity: 0.18)
                .animation(.spring(duration: 1.4), value: selectedEmotions)
            
            VStack(spacing: 0) {
                headerSection
                
                VStack(spacing: 24) {
                    Text("극을 관람할 때의 기억을\n감정 키워드로 표현해볼까요?")
                        .fontStyle(.headline2)
                        .foregroundStyle(.opacityWhite850)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(Emotion.allCases, id: \.self) { emotion in
                            emotionButton(emotion: emotion)
                        }
                    }
                    .padding(.bottom, 32)
                    .animation(.fastSpring, value: selectedEmotions)
                    
                    selectedEmotionSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                Spacer()
                
                DGButton(
                    text: "감정 등록 완료",
                    type: .primaryDark,
                    isDisabled: selectedEmotions.isEmpty || isLoading,
                ) {
                    updateEmotion(selectedEmotions)
                }
                
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
            }
        }
        .background(.bottomSheetBackground)
    }

    private var headerSection: some View {
        ZStack {
            Text("감정 남기기")
                .font(.headline2)
                .foregroundStyle(.opacityWhite800)
            
            Button(action: {
                dismiss()
            }) {
                Image("close")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(24)
    }

    private var selectedEmotionSection: some View {
        VStack(spacing: 16) {
            Text("선택된 감정 키워드")
                .font(.label1)
                .foregroundStyle(.opacityWhite700)
                
            if selectedEmotions.isEmpty {
                Text("-")
                    .font(.heading2)
                    .foregroundStyle(.opacityWhite700)
                    .padding(.horizontal, 22)
            } else {
                HStack {
                    ForEach(selectedEmotions, id: \.self) { emotion in
                        Text("#\(emotion.rawValue)")
                            .font(.heading2)
                            .foregroundStyle(.opacityWhite850)
                            .padding(.horizontal, 22)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func emotionButton(emotion: Emotion) -> some View {
        let isSelected = selectedEmotions.contains(emotion)

        Button(action: {
            if isSelected {
                selectedEmotions = selectedEmotions.filter {$0 != emotion}
            } else if selectedEmotions.count < 2 {
                selectedEmotions.append(emotion)
            }
        }) {
            Text(emotion.rawValue)
                .font(.body2)
                .foregroundStyle(isSelected ? .opacityWhite900 : .opacityWhite600)
                .frame(height: 54)
                .frame(maxWidth: .infinity)
                .background(isSelected ? emotion.color : .opacityWhite50, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.opacityWhite100, lineWidth: 1)
                )
        }
    }
}

#Preview {
    EmotionSelectionBottomSheet(
        currentEmotions: [.excited, .relaxed],
        updateEmotion: { _ in }
    )
}
