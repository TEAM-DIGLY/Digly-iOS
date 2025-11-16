import SwiftUI

struct DGTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var textColor: Color = .text100
    var placeholderColor: Color = .opacityBlack400
    var backgroundColor: Color = .opacityWhite800
    var borderColor: Color = .sbDefault
    var cursorColor: Color = .text100
    
    var isDeleteButtonPresent: Bool = false
    var onSubmit: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center) {
            TextField("", text: $text, prompt: prompt)
            .keyboardType(keyboardType)
            .focused($isFocused)
            
            .tint(cursorColor)
            .fontStyle(.headline1)
            .foregroundStyle(.common100)
            
            if isDeleteButtonPresent {
                Button(action: {
                    text = ""
                }) {
                    Image("x_circle")
                        .renderingMode(.template)
                        .foregroundStyle(cursorColor)
                }
                .opacity(isFocused ? 1 : 0)
                .scaleEffect(isFocused ? 1 : 0)
            }
        }
        .autocorrectionDisabled()
        .autocapitalization(.none)
        
        .padding(.horizontal, 16)
        .frame(height: 56, alignment: .center)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isFocused ? .sbDefault : .sbLight,
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .animation(.fastSpring, value: isFocused)
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
