import SwiftUI

struct DGTextField<T>: View where T: Hashable {
    @Binding var text: T
    @FocusState private var internalFocusState: Bool
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var textColor: Color = .text100
    var placeholderColor: Color = .opacityBlack55
    var backgroundColor: Color = .opacityWhite15
    var borderColor: Color = .sbDefault
    var cursorColor: Color = .text100
    
    var isFocused: FocusState<Bool>.Binding?
    
    var showClearButton: Bool = true
    var onClear: (() -> Void)?
    var onSubmit: (() -> Void)?
    
    private var isFieldFocused: Bool {
        isFocused?.wrappedValue ?? internalFocusState
    }
    
    var body: some View {
        HStack(alignment: .center) {
            TextField("",
                      text: Binding(
                        get: { String(describing: text) },
                        set: { if let value = $0 as? T { text = value } }
                      ),
                      prompt: prompt
            )
            .tint(cursorColor)
            .autocorrectionDisabled()
            .autocapitalization(.none)
            .fontStyle(.headline1)
            .foregroundStyle(.common100)
            .focused(isFocused ?? $internalFocusState)
            
            if showClearButton && isFieldFocused {
                Button(action: {
                    onClear?()
                    if let emptyValue = "" as? T {
                        text = emptyValue
                    }
                }) {
                    Image("x_circle")
                        .renderingMode(.template)
                        .foregroundStyle(cursorColor)
                }
                .opacity(isFieldFocused ? 1 : 0)
                .scaleEffect(isFieldFocused ? 1 : 0)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56, alignment: .center)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: isFieldFocused ? 1.5 : 1)
        )
        .animation(.fastSpring, value: isFieldFocused)
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
