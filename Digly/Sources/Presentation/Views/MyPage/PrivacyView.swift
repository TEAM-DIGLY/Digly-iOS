import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(.neutral5)
                }
                
                Spacer()
                
                Text("개인정보 처리방침")
                    .fontStyle(.headline2)
                    .foregroundStyle(.neutral5)
                
                Spacer()
                
                Button(action: {}) {
                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(.clear)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Spacer()
            
            Text("개인정보 수집 및 이용 동의 내역 화면")
                .fontStyle(.heading2)
                .foregroundStyle(.neutral35)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
    }
} 
