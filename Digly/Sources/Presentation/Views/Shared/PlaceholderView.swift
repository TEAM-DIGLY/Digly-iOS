import SwiftUI

struct PlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let subtitle: String
    
    var body: some View {
        DGScreen(backgroundColor: .common0) {
            VStack {
                BackNavWithTitle(
                    title: title,
                    backgroundColor: .common0
                ) {
                    Button("닫기") {
                        dismiss()
                    }
                    .fontStyle(.headline2)
                    .foregroundStyle(.common100)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.neutral45)
                    
                    Text(title)
                        .fontStyle(.heading2)
                        .foregroundStyle(.common100)
                    
                    Text(subtitle)
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral65)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PlaceholderView(
        title: "AddFeelingView",
        subtitle: "감정 입력 화면 (미구현)"
    )
}