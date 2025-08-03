import SwiftUI

struct DGToast: View {
    let toastType: ToastType
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: toastType.icon)
                .foregroundColor(iconColor)
                .font(.system(size: 16, weight: .medium))
            
            Text(toastType.text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let button = toastType.button {
                Button(action: button.onClick) {
                    Text(button.text)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 6)
                .disabled(button.disabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.1), radius: 16)
        )
    }
    
    private var iconColor: Color {
        switch toastType {
        case .error, .errorStringWithTask, .errorWithMessage:
            return .orange
        case .success:
            return .green
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DGToast(toastType: .success("성공적으로 완료되었어요."))
        DGToast(toastType: .errorStringWithTask("데이터 로딩"))
        DGToast(toastType: .errorWithMessage("네트워크 연결을 확인해 주세요."))
    }
    .padding()
}