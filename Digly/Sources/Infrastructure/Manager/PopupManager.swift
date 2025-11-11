import SwiftUI

final class PopupManager: ObservableObject {
    static let shared = PopupManager()

    private init() {}

    @Published var isPresented = false
    @Published var isAnimating = false

    private(set) var currentPopupType: PopupType?

    func show(_ type: PopupType) {
        currentPopupType = type
        isPresented = true
    }
    
    func dismissPopup() {
        isPresented = false
        isAnimating = false
    }
}
