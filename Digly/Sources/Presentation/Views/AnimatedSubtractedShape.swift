//
//  AnimatedSubtractedShape.swift
//  digly
//
//  Created by Neoself on 4/13/25.
//


import SwiftUI

// Shape 프로토콜을 사용한 애니메이션 구현
struct AnimatedSubtractedShape: View {
    @State private var isAnimating = false
    @State private var phase: CGFloat = 0
    let size: CGFloat = 160.0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ForEach(Array([1.4, 1.7, 1.8, 2.2, 2.6, 3.2, 4.2].enumerated()), id: \.element) { index, rate in
                let phaseOffset = CGFloat(index) * .pi / 2
                
                AnimatableShape(
                    rate: rate,
                    isReversed: false,
                    xOffset: -12 + 25 * cos(phase + phaseOffset),
                    yOffset: 12 + 12 * sin(phase + phaseOffset)
                )
                .fill (
                    LinearGradient(
                        colors: [Color("FF0000").opacity(0.4), Color("FF0000").opacity(0.2)],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ) )
                
                AnimatableShape(
                    rate: rate,
                    isReversed: true,
                    xOffset: 25 * cos(phase + phaseOffset),
                    yOffset: -12 + 12 * sin(phase + phaseOffset)
                )
                .fill(LinearGradient(
                    colors: [Color("FBB53B").opacity(0.28), Color("FF0000").opacity(0.08)],
                    startPoint: .topTrailing,
                    endPoint: .bottomTrailing
                ) )
            }
            .blur(radius: 0)
            .frame(width:size,height:size)
            .onReceive(timer) { _ in
                phase += 0.02
                if phase > .pi * 2 {
                    phase = 0
                }
            }
            .onDisappear { timer.upstream.connect().cancel() }
        }
        .frame(width:size,height:size)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 24,
                bottomTrailingRadius: size/2,
                topTrailingRadius: 24
            )
        )
        .shadow(color: .common0.opacity(0.4), radius: 8)
    }
}

// 애니메이션 가능한 Shape 정의
struct AnimatableShape: Shape {
    var rate: CGFloat
    var isReversed: Bool
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    // Animatable 프로퍼티 정의
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(xOffset, yOffset) }
        set {
            xOffset = newValue.first
            yOffset = newValue.second
        }
    }
    
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
    AnimatedSubtractedShape()
}
