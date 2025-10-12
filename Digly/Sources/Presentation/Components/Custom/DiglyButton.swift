import SwiftUI

struct DGButton: View {
    let config: ButtonConfig
    
    init(
        text: String,
        type: ButtonType = .primary,
        disabled: Bool = false,
        onClick: @escaping () -> Void = {}
    ) {
        self.config = ButtonConfig(
            text: text,
            type: type,
            onClick: onClick,
            disabled: disabled
        )
    }
    
    var body: some View {
        Button(action: config.onClick) {
            Text(config.text)
                .font(config.type.font)
                .foregroundStyle(config.disabled ? config.type.disabledForegroundColor : config.type.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: config.type.height)
                .background(config.disabled ? config.type.disabledBackgroundColor : config.type.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(config.type.strokeColor, lineWidth: 1)
                )
        }
        .disabled(config.disabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        DGButton(
            text: "활성화된 버튼",
            onClick: {}
        )
        
        DGButton(
            text: "비활성화된 버튼",
            disabled: true
        )
    }
    .padding()
}
