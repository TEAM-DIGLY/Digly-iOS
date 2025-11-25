import SwiftUI

struct EmotionBackgroundGradient: View {
    let selectedEmotions: [Emotion]

    var body: some View {
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
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        EmotionBackgroundGradient(selectedEmotions: [.excited, .relaxed])
    }
}
