import SwiftUI

enum TextFieldType {
    case createTicketOptional
    case createTicket
    case inquiry
    case inquiryEmail
    case profileSetting
    
    var textColor: Color {
        switch self {
        case .createTicketOptional:
                .neutral100
        case .createTicket:
                .neutral100
        case .inquiry, .inquiryEmail:
                .text0
        case .profileSetting:
                .text0
        }
    }
    
    var placeholderColor: Color {
        switch self {
        case .createTicketOptional:
                .opacityWhite300
        case .inquiry, .inquiryEmail:
                .opacityWhite300
        case .createTicket:
                .opacityWhite300
        case .profileSetting:
                .opacityWhite300
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .createTicketOptional:
                .opacityWhite50
        case .createTicket:
                .opacityWhite50
        case .inquiry, .inquiryEmail:
                .neutral50
        case .profileSetting:
                .neutral50
        }
    }
    
    var borderColor: Color {
        switch self {
        case .createTicketOptional:
                .opacityWhite100
        case .createTicket:
                .opacityWhite100
        case .inquiry, .inquiryEmail, .profileSetting:
                .clear
        }
    }
    
    var cursorColor: Color {
        switch self {
        case .createTicketOptional:
                .common100
        case .createTicket:
                .common100
        case .inquiry, .inquiryEmail:
                .text0
        case .profileSetting:
                .text0
        }
    }
    
    var isDeleteButtonPresent: Bool {
        switch self {
        case .createTicketOptional:
            false
        case .createTicket:
               true
        case .inquiry, .inquiryEmail:
            true
        case .profileSetting:
            true
        }
    }
}


struct DGTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let placeholder: String
    let type: TextFieldType
    
    var onSubmit: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: $text, prompt: prompt)
                .focused($isFocused)
            
                .tint(type.cursorColor)
                .fontStyle(.headline1)
                .foregroundStyle(type.textColor)
                .frame(maxWidth: .infinity)
            
            Button(action: {
                text = ""
            }) {
                Image("x_circle")
                    .renderingMode(.template)
                    .foregroundStyle(type.cursorColor)
                    .padding(.horizontal, 8)
            }
            .opacity(type.isDeleteButtonPresent && isFocused ? 1 : 0)
            .scaleEffect(type.isDeleteButtonPresent && isFocused ? 1 : 0)
        }
        .autocorrectionDisabled()
        .autocapitalization(.none)
        
        .padding(.leading, 16)
        .frame(height: 56, alignment: .center)
        .background(type.backgroundColor, in: RoundedRectangle(cornerRadius: 16))
        .animation(.mediumSpring, value: isFocused)
        .onSubmit { onSubmit?() }
    }
    
    private var prompt: Text {
        Text(placeholder)
            .font(.headline1)
            .foregroundColor(type.placeholderColor)
    }
}
