import SwiftUI

struct DGTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var textColor: Color = .text0
    var placeholderColor: Color = .neutral300
    var backgroundColor: Color = .opacityWhite800
    var borderColor: Color = .sbDefault
    var cursorColor: Color = .text0
    
    var isDeleteButtonPresent: Bool = false
    var onSubmit: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: $text, prompt: prompt)
                .keyboardType(keyboardType)
                .focused($isFocused)
            
                .tint(cursorColor)
                .fontStyle(.headline1)
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
            
            Button(action: {
                text = ""
            }) {
                Image("x_circle")
                    .renderingMode(.template)
                    .foregroundStyle(cursorColor)
                    .padding(.horizontal, 8)
            }
            .background(backgroundColor.opacity(0.5))
            .opacity(isFocused ? 1 : 0)
            .scaleEffect(isFocused ? 1 : 0)
        }
        .autocorrectionDisabled()
        .autocapitalization(.none)
        
        .padding(.leading, 16)
        .frame(height: 56, alignment: .center)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 16))
        .animation(.mediumSpring, value: isFocused)
        .onSubmit { onSubmit?() }
    }
    
    private var prompt: Text {
        Text(placeholder)
            .font(.headline1)
            .foregroundColor(placeholderColor)
    }
}
