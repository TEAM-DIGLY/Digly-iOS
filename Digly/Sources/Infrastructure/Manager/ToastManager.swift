import SwiftUI

final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var toastPresented: Bool = false
    @Published private(set) var currentToastType: ToastType?
    
    private init() {}
    
    func show(_ type: ToastType, isDelayNeeded: Bool = false) {
        if isDelayNeeded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self._show(type)
            }
        } else {
            _show(type)
        }
    }
    
    private func _show(_ type: ToastType) {
        if toastPresented {
            reset()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.currentToastType = type
                self.toastPresented = true
            }
        } else {
            currentToastType = type
            toastPresented = true
        }
    }
    
    func reset() {
        toastPresented = false
        currentToastType = nil
    }
}