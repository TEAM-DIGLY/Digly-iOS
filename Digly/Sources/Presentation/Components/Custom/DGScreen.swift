import SwiftUI

struct DGScreen<Content: View>: View {
    let content: Content
    let horizontalPadding: CGFloat
    let isAlignCenter: Bool
    let isLoading: Bool
    
    init(
        horizontalPadding: CGFloat = 16,
        isAlignCenter: Bool = false,
        isLoading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.isAlignCenter = isAlignCenter
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: isAlignCenter ? .center : .leading, spacing: 0) {
            content
        }
        .padding(.horizontal, horizontalPadding)
        .background(.common100)
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
