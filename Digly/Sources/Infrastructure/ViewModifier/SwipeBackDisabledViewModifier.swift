import SwiftUI

struct SwipeBackDisabledViewModifier: ViewModifier {
    let isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                SwipeBackManager.shared.updateSwipeBackDisabled(to: isDisabled)
            }
    }
}
