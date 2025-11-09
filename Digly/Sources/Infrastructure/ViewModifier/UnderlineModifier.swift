import SwiftUI

struct UnderlineModifier: ViewModifier {
    let color: Color
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(color)
                    .frame(height: lineHeight)
                    .offset(y: 0),
                alignment: .bottom
            )
    }
}
