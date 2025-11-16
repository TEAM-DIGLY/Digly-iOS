import SwiftUI

struct AgreementDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let agreementType: AgreementType

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
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
            .padding(.horizontal, 25)
            .padding(.vertical, 8)

            ScrollView {
                Text(agreementType.content)
                    .fontStyle(.body2)
                    .foregroundStyle(.common0)
                    .opacity(0.7)
                    .padding(.horizontal, 32)
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .background(Color.common100)
        .navigationBarHidden(true)
    }
}

#Preview {
    AgreementDetailView(agreementType: .service)
}
