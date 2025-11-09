import SwiftUI

struct DGLoadingIndicator: View {
    let isFullScreen: Bool
    
    init(isFullScreen: Bool = true){
        self.isFullScreen = isFullScreen
    }
    
    var body: some View {
        if isFullScreen {
            ProgressView()
                .tint(.opacityWhite600)
                .scaleEffect(1.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            ProgressView()
                .tint(.opacityWhite600)
                .scaleEffect(1.2)
        }
    }
}
