import SwiftUI

struct DGPopup: View {
    let hidePopup: () -> Void
    let popupData: PopupData
    
    var body: some View {
        let popup = popupData.type

        VStack(spacing: 0) {
            // Icon
            HStack {
                Image(popup.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.common100)
                    .frame(width: 24, height: 24)

                Spacer()
            }
            .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 12) {
                Text(popup.title)
                    .fontStyle(.heading2)
                    .foregroundColor(.common100)

                Text(popup.description)
                    .fontStyle(.body2)
                    .foregroundColor(.opacityWhite600)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 24)

            HStack(spacing: 12) {
                if !popup.secondaryButtonText.isEmpty {
                    buttonSection(popup.secondaryButtonText, isPrimary: false) {
                        hidePopup()
                    }
                }

                buttonSection(popup.primaryButtonText, isPrimary: true) {
                    popupData.action()
                    hidePopup()
                }
            }
        }
        .padding(24)
        .background(.common0, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 24)
    }
    
    private func buttonSection(_ text: String, isPrimary: Bool, action: @escaping ()-> Void)-> some View {
        Button(action: action) {
            Text(text)
                .fontStyle(.body1)
                .foregroundColor(isPrimary ? .common0 : .opacityWhite600)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(isPrimary ? .common100 : .opacityWhite850)
                .cornerRadius(12)
        }
    }
}


#Preview {
    Preview_wrapper()
}
struct Preview_wrapper: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity( 0.3)
            
            DGPopup(
                hidePopup: {},
                popupData: PopupData(type: .updateMandatory, action: {})
            )
        }
    }
}
