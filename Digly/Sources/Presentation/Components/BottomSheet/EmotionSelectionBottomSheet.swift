import SwiftUI

struct EmotionSelectionBottomSheet: View {
    let ticketId: Int
    let currentEmotions: [Emotion]
    let onEmotionsUpdated: ([Emotion]) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedEmotions: [Emotion] = []
    @State private var isLoading: Bool = false

    private let ticketUseCase: TicketUseCase

    init(
        ticketId: Int,
        currentEmotions: [Emotion],
        onEmotionsUpdated: @escaping ([Emotion]) -> Void,
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.ticketId = ticketId
        self.currentEmotions = currentEmotions
        self.onEmotionsUpdated = onEmotionsUpdated
        self.ticketUseCase = ticketUseCase
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundGradient
                .animation(.spring(duration: 1.4), value: selectedEmotions)
            
            VStack(spacing: 0) {
                headerSection
                
                VStack(spacing: 24) {
                    Text("극을 관람할 때의 기억을\n감정 키워드로 표현해볼까요?")
                        .fontStyle(.headline2)
                        .foregroundStyle(.opacityWhite850)
                        .multilineTextAlignment(.center)
                    
                    emotionGridSection
                        .padding(.bottom, 32)
                        .animation(.fastSpring, value: selectedEmotions)
                    
                    selectedEmotionSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                Spacer()
                
                bottomButton
            }
        }
        .background(.bottomSheetBackground)
        .onAppear {
            selectedEmotions = currentEmotions
        }
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

    private var emotionGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(Emotion.allCases, id: \.self) { emotion in
                emotionButton(emotion: emotion)
            }
        }
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

    private var bottomButton: some View {
        DGButton(
            text: "감정 등록 완료",
            type: .primaryDark,
            isDisabled: selectedEmotions.isEmpty || isLoading,
            onClick: {
                updateTicketEmotions()
            }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
    }
    
@ViewBuilder
    private var backgroundGradient: some View {
        ZStack {
            // 1
            Circle()
                .fill(circleColor(for: 0))
                .blur(radius: 8)
                .frame(width: 424, height: 424)
                .offset(x: 64, y: 72)
            // 2
            Circle()
                .fill(circleColor(for: 1))
                .blur(radius: 8)
                .frame(width: 363, height: 363)
                .offset(x: 93, y: 32)
            // 3
            Circle()
                .fill(circleColor(for: 2))
                .blur(radius: 8)
                .frame(width: 300, height: 300)
                .offset(x: -94, y: 0)
            // 4
            Circle()
                .fill(circleColor(for: 3))
                .blur(radius: 8)
                .frame(width: 424, height: 424)
                .offset(x: -64, y: 72)
            // 5
            Circle()
                .fill(circleColor(for: 4))
                .blur(radius: 8)
                .frame(width: 363, height: 363)
                .offset(x: -93, y: 32)
            // 6
            Circle()
                .fill(circleColor(for: 5))
                .blur(radius: 8)
                .frame(width: 300, height: 300) 
                .offset(x: 94, y: 0)
        }
        .offset(y: 100)
    }

    private func circleColor(for index: Int) -> Color {
        if selectedEmotions.isEmpty {
            return .opacityWhite50
        } else if selectedEmotions.count == 1 {
            return selectedEmotions[0].color50.opacity(0.18)
        } else {
            if index < 3 {
                return selectedEmotions[0].color50.opacity(0.18)
            } else {
                return selectedEmotions[1].color50.opacity(0.18)
            }
        }
    }

    private func updateTicketEmotions() {
        Task {
            do {
                isLoading = true
                
                // Call API to update ticket emotions
                let emotionsArray = Array(selectedEmotions)
                let _ = try await ticketUseCase.updateTicketEmotions(
                    ticketId: ticketId,
                    emotions: emotionsArray
                )
                
                await MainActor.run {
                    onEmotionsUpdated(emotionsArray)
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    ToastManager.shared.show(.errorStringWithTask("감정 등록"))
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    EmotionSelectionBottomSheet(
        ticketId: 1,
        currentEmotions: [.excited, .relaxed],
        onEmotionsUpdated: { _ in }
    )
}
