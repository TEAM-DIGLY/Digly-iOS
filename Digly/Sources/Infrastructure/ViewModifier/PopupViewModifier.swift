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
                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                            .opacity(manager.isAnimating ? 0.3 : 0.0)
                            .onTapGesture {
                                if popupType.config.isOptional { manager.dismissPopup() }
                            }
                            .animation(.fastSpring, value: manager.isAnimating)

                        popupContent(for: popupType)
                            .opacity(manager.isAnimating ? 1 : 0)
                            .offset(y: manager.isAnimating ? 0 : -80)
                            .animation(.mediumSpring, value: manager.isAnimating)
                    }
                }
            }
            .onChange(of: manager.isPresented) { _, newValue in
                manager.isAnimating = newValue
            }
    }

    @ViewBuilder
    private func popupContent(for popupType: PopupType) -> some View {
        if case .custom(let view) = popupType {
            AnyView(view)
        } else {
            DGPopup(
                hidePopup: manager.dismissPopup,
                type: popupType
            )
        }
    }

}
