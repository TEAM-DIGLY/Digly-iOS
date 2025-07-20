import SwiftUI

struct OverlappingCirclesShape: View {
    let circleConfigs: [CircleConfig]
    
    var body: some View {
        ZStack {
            ForEach(circleConfigs.indices, id: \.self) { index in
                let config = circleConfigs[index]
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.common100.opacity(config.opacity), .common100.opacity(0.01)],
                            startPoint: config.gradientDirection == .leftToRight ? .topLeading : .topTrailing,
                            endPoint: config.gradientDirection == .leftToRight ? .bottomTrailing : .bottomLeading
                        )
                    )
                    .frame(
                        width: config.diameter,
                        height: config.diameter
                    )
                    .offset(
                        x: config.xOffset,
                        y: config.yOffset
                    )
            }
        }
    }
}
enum GradientDirection {
    case leftToRight
    case rightToLeft
}


struct CircleConfig {
    let diameter: CGFloat
    let xOffset: CGFloat
    let yOffset: CGFloat
    let opacity: CGFloat
    let gradientDirection: GradientDirection
}

// MARK: - Preset Configurations
extension OverlappingCirclesShape {
    static func ticketDetailPattern() -> OverlappingCirclesShape {
        let baseOffset:CGFloat = -50
        let configs = [
            // 중앙 큰 원들
            CircleConfig(
                diameter: 160,
                xOffset: -40,
                yOffset: baseOffset,
                opacity: 0.24,
                gradientDirection: .rightToLeft
            ),
            CircleConfig(
                diameter: 160,
                xOffset: 40,
                yOffset: baseOffset,
                opacity: 0.24,
                gradientDirection: .leftToRight
            ),

            CircleConfig(
                diameter: 130,
                xOffset: -40,
                yOffset: baseOffset-12,
                opacity: 0.16,
                gradientDirection: .rightToLeft
            ),
            CircleConfig(
                diameter: 130,
                xOffset: 40,
                yOffset: baseOffset-12,
                opacity: 0.16,
                gradientDirection: .leftToRight
            ),
            CircleConfig(
                diameter: 190,
                xOffset: -30,
                yOffset: baseOffset+10,
                opacity: 0.16,
                gradientDirection: .rightToLeft
            ),
            CircleConfig(
                diameter: 190,
                xOffset: 30,
                yOffset: baseOffset+10,
                opacity: 0.16,
                gradientDirection: .leftToRight
            ),
        ]
        
        return OverlappingCirclesShape(circleConfigs: configs)
    }
} 
