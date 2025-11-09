import SwiftUI

struct EmotionSelection2BottomSheet: View {
    let ticketId: Int
    @Binding var currentEmotions: [EmotionColor]
    let onEmotionsUpdated: ([EmotionColor]) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedEmotions: Set<EmotionColor> = []
    @State private var isLoading: Bool = false

    private let ticketUseCase: TicketUseCase

    init(
        ticketId: Int,
        currentEmotions: Binding<[EmotionColor]>,
        onEmotionsUpdated: @escaping ([EmotionColor]) -> Void,
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.ticketId = ticketId
        self._currentEmotions = currentEmotions
        self.onEmotionsUpdated = onEmotionsUpdated
        self.ticketUseCase = ticketUseCase
    }

    private let emotionGrid = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            VStack(spacing: 24) {
                titleSection
                emotionGridSection
                selectedEmotionsSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Spacer()

            bottomButton
        }
        .background(backgroundGradient)
        .onAppear {
            selectedEmotions = Set(currentEmotions)
        }
    }

    private var headerSection: some View {
        HStack {
            Spacer()

            Button(action: {
                dismiss()
            }) {
                Image("close")
                    .foregroundStyle(.common100)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("관람하며 느낀 감정을")
                .fontStyle(.heading1)
                .foregroundStyle(.common100)

            Text("선택해주세요")
                .fontStyle(.heading1)
                .foregroundStyle(.common100)
        }
    }

    private var emotionGridSection: some View {
        LazyVGrid(columns: emotionGrid, spacing: 16) {
            ForEach(EmotionColor.allCases, id: \.self) { emotion in
                emotionButton(emotion: emotion)
            }
        }
    }

    private func emotionButton(emotion: EmotionColor) -> some View {
        let isSelected = selectedEmotions.contains(emotion)

        return Button(action: {
            if isSelected {
                selectedEmotions.remove(emotion)
            } else {
                selectedEmotions.insert(emotion)
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(emotion.color)
                        .frame(width: 64, height: 64)

                    if isSelected {
                        Circle()
                            .stroke(.common100, lineWidth: 3)
                            .frame(width: 64, height: 64)

                        Image(systemName: "checkmark")
                            .foregroundStyle(.common100)
                            .font(.system(size: 16, weight: .bold))
                    }
                }

                Text(emotion.displayName)
                    .fontStyle(.body2)
                    .foregroundStyle(isSelected ? .common100 : .opacityWhite300)
            }
        }
        .frame(height: 96)
    }

    @ViewBuilder
    private var selectedEmotionsSection: some View {
        if !selectedEmotions.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("선택된 감정")
                        .fontStyle(.body1)
                        .foregroundStyle(.opacityWhite300)

                    Spacer()
                }

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(Array(selectedEmotions).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { emotion in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(emotion.color)
                                .frame(width: 16, height: 16)

                            Text(emotion.displayName)
                                .fontStyle(.body2)
                                .foregroundStyle(.common100)

                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.opacityWhite600, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.top, 16)
        }
    }

    private var bottomButton: some View {
        DGButton(
            text: "감정 등록 완료",
            type: .primaryDark,
            disabled: selectedEmotions.isEmpty || isLoading,
            onClick: {
                updateTicketEmotions()
            }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
    }

    private var backgroundGradient: some View {
        ZStack {
            Color.common0

            // Background circles for visual interest
            Circle()
                .fill(.opacityWhite850)
                .frame(width: 200, height: 200)
                .offset(x: -100, y: -150)

            Circle()
                .fill(.opacityWhite850)
                .frame(width: 150, height: 150)
                .offset(x: 120, y: 100)
        }
        .ignoresSafeArea()
    }

    private func updateTicketEmotions() {
        Task {
            do {
                isLoading = true
                
                // Call API to update ticket emotions
                let emotionsArray = Array(selectedEmotions)
                let success = try await ticketUseCase.updateTicketEmotions(
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
    EmotionSelection2BottomSheet(
        ticketId: 1,
        currentEmotions: .constant([.excited, .glad]),
        onEmotionsUpdated: { _ in }
    )
}
