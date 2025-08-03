import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(.neutral5)
                }
                
                Spacer()
                
                Text("이용약관")
                    .fontStyle(.headline2)
                    .foregroundStyle(.neutral5)
                
                Spacer()
                
                // Invisible button for balance
                Button(action: {}) {
                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(.clear)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Spacer()
            
            Text("이용약관 화면")
                .fontStyle(.heading2)
                .foregroundStyle(.neutral35)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
        TermsView()
    
} 
