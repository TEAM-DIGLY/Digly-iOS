import SwiftUI

struct EmotionSelectionBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var selectedEmotions: [Emotion] = []
    let onComplete: ([Emotion]) -> Void

    private let emotions: [Emotion] = [
        .distressed, .excited, .glad,
        .gloomy, .relaxed, .satisfied
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Handle bar
            RoundedRectangle(cornerRadius: 2)
                .fill(.neutral400)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            // Header
            HStack {
                Spacer()

                Text("감정 남기기")
                    .fontStyle(.headline2)
                    .foregroundStyle(.neutral900)

                Spacer()

                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18))
                        .foregroundStyle(.neutral900)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)

            // Description
            Text("극을 관람할 때의 기억을\n감정 키워드로 표현해볼까요?")
                .fontStyle(.body1)
                .foregroundStyle(.neutral800)
                .multilineTextAlignment(.center)
                .padding(.top, 32)

            // Emotion buttons grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(emotions, id: \.self) { emotion in
                    emotionButton(emotion: emotion)
                }
            }
            .padding(.horizontal, 29)
            .padding(.top, 40)

            // Selected emotions label
            Text("선택된 감정 키워드")
                .fontStyle(.label1)
                .foregroundStyle(.neutral800)
                .padding(.top, 32)

            // Selected emotions display
            HStack(spacing: 12) {
                ForEach(selectedEmotions, id: \.self) { emotion in
                    Text("#\(emotion.rawValue)")
                        .fontStyle(.body1)
                        .foregroundStyle(emotion.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            emotion.color50,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                }
            }
            .frame(height: 32)
            .padding(.top, 16)

            Spacer()

            // Complete button
            Button(action: {
                onComplete(selectedEmotions)
                withAnimation {
                    isPresented = false
                }
            }) {
                Text("감정 등록 완료")
                    .fontStyle(.body1)
                    .foregroundStyle(.common100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        selectedEmotions.isEmpty ? Color.neutral300 : Color.opacityCool900,
                        in: RoundedRectangle(cornerRadius: 16)
                    )
            }
            .disabled(selectedEmotions.isEmpty)
            .padding(.horizontal, 23)
            .padding(.bottom, 10)

            // Home indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(.neutral900)
                .frame(width: 133, height: 4)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(.common100)
        .cornerRadius(24, corners: [.topLeft, .topRight])
    }

    private func emotionButton(emotion: Emotion) -> some View {
        let isSelected = selectedEmotions.contains(emotion)

        return Button(action: {
            withAnimation(.fastEaseInOut) {
                if isSelected {
                    selectedEmotions.removeAll { $0 == emotion }
                } else {
                    if selectedEmotions.count < 2 {
                        selectedEmotions.append(emotion)
                    }
                }
            }
        }) {
            Text(emotion.rawValue)
                .fontStyle(.body1)
                .foregroundStyle(isSelected ? .common100 : .neutral900)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isSelected ? emotion.color : Color.neutral150,
                    in: RoundedRectangle(cornerRadius: 12)
                )
        }
    }
}

// Helper extension for corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    EmotionSelectionBottomSheet(
        isPresented: .constant(true),
        onComplete: { _ in }
    )
}
