import SwiftUI

struct EmotionBackgroundGradient: View {
    let selectedEmotions: [Emotion]
    let size: CGFloat
    let opacity: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(circleColor(for: 0))
                .blur(radius: 8)
                .frame(width: size, height: size)
                .offset(x: size*0.15, y: size*0.17)
            Circle()
                .fill(circleColor(for: 1))
                .blur(radius: 8)
                .frame(width: size*0.85, height: size*0.85)
                .offset(x: size*0.22, y: size*0.075)
            
            Circle()
                .fill(circleColor(for: 2))
                .blur(radius: 8)
                .frame(width: size*0.7, height: size*0.7)
                .offset(x: -(size*0.22), y: 0)
            
            Circle()
                .fill(circleColor(for: 3))
                .blur(radius: 8)
                .frame(width: size, height: size)
                .offset(x: -(size*0.15), y: size*0.17)
            
            Circle()
                .fill(circleColor(for: 4))
                .blur(radius: 8)
                .frame(width: size*0.85, height: size*0.85)
                .offset(x: -(size*0.22), y: size*0.075)
            
            Circle()
                .fill(circleColor(for: 5))
                .blur(radius: 8)
                .frame(width: size*0.7, height: size*0.7)
                .offset(x: size*0.22, y: 0)
        }
        .offset(y: 100)
    }

    private func circleColor(for index: Int) -> Color {
        if selectedEmotions.isEmpty {
            return .opacityWhite50
        } else if selectedEmotions.count == 1 {
            return selectedEmotions[0].color50.opacity(opacity)
        } else {
            if index < 3 {
                return selectedEmotions[0].color50.opacity(opacity)
            } else {
                return selectedEmotions[1].color50.opacity(opacity)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        EmotionBackgroundGradient(selectedEmotions: [.excited, .relaxed], size: 424, opacity: 0.18)
    }
}
