import SwiftUI

struct DGToast: View {
    let toastType: ToastType
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: toastType.icon)
                .foregroundColor(iconColor)
                .font(.system(size: 16, weight: .medium))
            
            Text(toastType.text)
                .font(.label1)
                .foregroundColor(.neutral50)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.grayscale700, in: RoundedRectangle(cornerRadius: 8))
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
