import SwiftUI

struct DGScreen<Content: View>: View {
    let content: Content
    let horizontalPadding: CGFloat
    let backgroundColor: Color
    let isAlignCenter: Bool
    let isLoading: Bool
    
    init(
        horizontalPadding: CGFloat = 16,
        backgroundColor: Color = .common100,
        isAlignCenter: Bool = false,
        isLoading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.backgroundColor = backgroundColor
        self.isAlignCenter = isAlignCenter
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: isAlignCenter ? .center : .leading, spacing: 0) {
            content
        }
        .padding(.horizontal, horizontalPadding)
        .background(backgroundColor)
        .navigationBarBackButtonHidden(true)
        .overlay {
            Group {
                if isLoading {
                    DGLoadingIndicator()
                }
            }
        }
    }
}
