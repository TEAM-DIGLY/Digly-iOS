import SwiftUI

final class PopupManager: ObservableObject {
    static let shared = PopupManager()
    
    private init() {}
    
    @Published var popupPresented = false
    
    private(set) var currentPopupData: PopupData?
    
    func show(type: PopupType, action: @escaping () -> Void) {
        currentPopupData = PopupData(type: type, action: action)
        popupPresented = true
    }
}
