import SwiftUI

struct DGPopup: View {
    let hidePopup: () -> Void
    let popupData: PopupData
    
    var body: some View {
        let popup = popupData.type

        VStack(spacing: 0) {
            // Icon
            if !popup.image.isEmpty {
                Image(popup.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.common100)
                    .frame(width: 24, height: 24)
            }

            VStack(alignment: popup.isDarkMode ? .center : .leading, spacing: 12) {
                Text(popup.title)
                    .fontStyle(popup.isDarkMode ? .body2 :.heading2)
                    .foregroundColor(.common100)

                Text(popup.description)
                    .fontStyle(popup.isDarkMode ? .label2 : .body2)
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
        .background(popup.isDarkMode ? .bottomSheetBackground : .common0, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func buttonSection(_ text: String, isPrimary: Bool, action: @escaping ()-> Void)-> some View {
        var buttonForegroundColor: Color {
            if popupData.type.isDarkMode {
                return .opacityWhite850
            } else {
                if isPrimary {
                    return .common0
                } else {
                    return .opacityWhite600
                }
            }
        }
        var buttonBackgroundColor: Color {
            if popupData.type.isDarkMode {
                return Color.clear
            } else {
                if isPrimary {
                    return .common100
                } else {
                    return .opacityWhite850
                }
            }
        }
        
        Button(action: action) {
            Text(text)
                .fontStyle(popupData.type.isDarkMode ? .label2 : .body1)
                .foregroundColor(buttonForegroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(buttonBackgroundColor)
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
