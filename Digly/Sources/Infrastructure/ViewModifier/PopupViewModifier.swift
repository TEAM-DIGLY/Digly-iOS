import SwiftUI

extension View {
    func presentPopup(_ popupManager: PopupManager) -> some View {
        modifier(PopupViewModifier(manager: popupManager))
    }
}

struct PopupViewModifier: ViewModifier {
    @ObservedObject var manager: PopupManager

    func body(content: Content) -> some View {
        content
            .overlay {
                if manager.isPresented, let popupType = manager.currentPopupType {
                    if case .custom(let view) = popupType {
                        // Custom views handle their own background and animation
                        AnyView(view)
                    } else {
                        ZStack {
                            Color.black
                                .edgesIgnoringSafeArea(.all)
                                .opacity(manager.isAnimating ? 0.3 : 0.0)
                                .onTapGesture {
                                    if popupType.config.isOptional { manager.dismissPopup() }
                                }
                                .animation(.fastSpring, value: manager.isAnimating)

                            DGPopup(
                                hidePopup: manager.dismissPopup,
                                type: popupType
                            )
                            .opacity(manager.isAnimating ? 1 : 0)
                            .offset(y: manager.isAnimating ? 0 : -80)
                            .animation(.mediumSpring, value: manager.isAnimating)
                        }
                    }
                }
            }
            .onChange(of: manager.isPresented) { _, newValue in
                if case .custom = manager.currentPopupType {
                    // Custom views don't use the isAnimating state
                    return
                }
                manager.isAnimating = newValue
            }
    }

}
