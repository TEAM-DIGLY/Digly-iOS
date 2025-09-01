import SwiftUI

struct DGTextField<T>: View where T: Hashable {
    @Binding var text: T
    @FocusState private var isFocused: Bool
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var onSubmit: (() -> Void)?
    var textColor: Color = .text100
    var placeholderColor: Color = .opacityBlack55
    var backgroundColor: Color = .opacityWhite15
    var borderColor: Color = .sbDefault
    
    var body: some View {
        TextField("",
                  text: Binding(
                    get: { String(describing: text) },
                    set: { if let value = $0 as? T { text = value } }
                  ),
                  prompt: prompt
        )
        .autocorrectionDisabled()
        .autocapitalization(.none)
        
        .fontStyle(.headline1)
        .foregroundStyle(.common100)
        
        .padding(16)
        .frame(height: 56, alignment: .center)
        
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: isFocused ? 1.5 : 1)
        )
        
        .animation(.fastSpring, value: isFocused)
        .keyboardType(keyboardType)
        .onSubmit {
            onSubmit?()
        }
    }
    
    private var prompt: Text {
        Text(placeholder)
            .font(.headline1)
            .foregroundColor(placeholderColor)
    }
}
