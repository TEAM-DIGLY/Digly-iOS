import SwiftUI

struct DGButton: View {
    let text: LocalizedStringResource
    let type: ButtonType
    var isLoading: Bool
    var isDisabled: Bool
    let onClick: () -> Void
    
    init(
        text: LocalizedStringResource,
        type: ButtonType = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        onClick: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.onClick = onClick
    }
    
    private var indicatorColor: Color {
        type == .primary && !isDisabled ? .common100 : .opacityCool50
    }
    
    var body: some View {
        Button(action: onClick) {
            ZStack {
                Text(text)
                    .font(type.font)
                    .opacity(isLoading ? 0 : 1)
                    .foregroundStyle(isDisabled ? type.disabledForegroundColor : type.foregroundColor)
                
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(indicatorColor)
                    .opacity(isLoading ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: type.height)
            
        }
        .background(isDisabled ? type.disabledBackgroundColor : type.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(type.strokeColor, lineWidth: 1)
        )
        .disabled(isDisabled)
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
            isDisabled: true
        ){}
    }
    .padding()
}
