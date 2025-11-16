import SwiftUI

struct AgreementDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let agreementType: AgreementType

    var body: some View {
        DGScreen(horizontalPadding: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(.common0)
                }
                
                Text(agreementType.title)
                    .fontStyle(.heading2)
                    .foregroundStyle(.common0)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
            ScrollView {
                Text(agreementType.content)
                    .fontStyle(.body2)
                    .foregroundStyle(.common0)
                    .padding(.horizontal, 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AgreementDetailView(agreementType: .service)
}
