import SwiftUI

struct DiglyShape: View {
    let upperGradientColors: [Color]
    let bottomGradientColors: [Color]
    let patterns: [CGFloat]
    let offsets: [CGFloat]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ForEach(patterns, id: \.self) { rate in
                SubtractedShape(
                    rate: rate,
                    isReversed: true,
                    xOffset: offsets[0],
                    yOffset: offsets[1]
                )
                .fill(LinearGradient(
                    colors: upperGradientColors,
                    startPoint: .topTrailing,
                    endPoint: .bottomTrailing
                ) )
                
                SubtractedShape(
                    rate: rate,
                    xOffset: offsets[2],
                    yOffset: offsets[3]
                )
                .fill (
                    LinearGradient(
                        colors: bottomGradientColors,
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ) )
            }
            
        }
    }
}

struct SubtractedShape: Shape {
    var rate: CGFloat
    var isReversed: Bool = false
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        let circleDiameter: CGFloat = rect.width * rate
        var circleOrigin: CGPoint
        if isReversed {
            circleOrigin = CGPoint(x: xOffset - circleDiameter * 0.5, y: yOffset)
        } else {
            circleOrigin = CGPoint(x: xOffset, y: yOffset - circleDiameter * 0.5)
        }
        
        let circlePath = Path(ellipseIn: CGRect(
            x: circleOrigin.x,
            y: circleOrigin.y,
            width: circleDiameter,
            height: circleDiameter
        ))
        
        return path.subtracting(circlePath)
    }
}

#Preview {
    DiglyShape(
        upperGradientColors: [.red.opacity(0.1),.blue.opacity(0.1)],
               
        bottomGradientColors: [.blue.opacity(0.1),.green.opacity(0.1)],
        patterns: [0, 1.2, 1.6, 2.0, 2.6, 3.0, 3.2],
        offsets: [0,1,2,3]
    )
}
