import SwiftUI

struct CustomTextField<T>: View where T: Hashable {
    @Binding var text: T
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var onSubmit: (() -> Void)?
    var textColor: Color = .text100
    var placeholderColor: Color = .opacity55
    var backgroundColor: Color = .opacity15
    var borderColor: Color = .sbDefault
    
    var body: some View {
        TextField("",
                  text: Binding(
                    get: { String(describing: text) },
                    set: { if let value = $0 as? T { text = value } }
                  ),
                  prompt: Text(placeholder).foregroundColor(placeholderColor)
        )
        .foregroundColor(textColor)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(backgroundColor))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 1)
        )
        .autocapitalization(.none)
        .keyboardType(keyboardType)
        .onSubmit {
            onSubmit?()
        }
    }
}
