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
    var isProfileStyle: Bool = false
    
    var body: some View {
        if isProfileStyle {
            VStack(alignment: .leading, spacing: 0) {
                TextField("",
                          text: Binding(
                            get: { String(describing: text) },
                            set: { if let value = $0 as? T { text = value } }
                          ),
                          prompt: nil
                )
                .foregroundColor(.neutral5)
                .fontStyle(.body2)
                .padding(.vertical, 8)
                .autocapitalization(.none)
                .keyboardType(keyboardType)
                .onSubmit {
                    onSubmit?()
                }
                
                Rectangle()
                    .fill(.neutral75)
                    .frame(height: 1)
            }
        } else {
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
    
    // Profile style initializer
    static func profileStyle(text: Binding<T>) -> CustomTextField<T> {
        CustomTextField(
            text: text,
            placeholder: "",
            isProfileStyle: true
        )
    }
}
