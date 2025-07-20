import SwiftUI

extension View {
    func fontStyle(_ font: Font) -> some View {
        self.font(font)
            .lineSpacing(CGFloat(font.lineSpacing))
    }
    
    func swipeBackDisabled(_ isDisabled: Bool) -> some View {
        modifier(SwipeBackDisabledViewModifier(isDisabled: isDisabled))
    }
    
    func presentPopup(isPresented: Binding<Bool>, data: PopupData?) -> some View {
        modifier(PopupViewModifier(isPresented: isPresented, data: data))
    }
    
    func textInputLimit(text: Binding<String>, maxLength: Int) -> some View {
        self.modifier(TextInputLimitModifier(text: text, maxLength: maxLength))
    }
}
