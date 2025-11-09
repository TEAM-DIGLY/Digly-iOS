import SwiftUI

struct DGPopup: View {
    let hidePopup: () -> Void
    let popupData: PopupData
    
    var body: some View {
        let popup = popupData.type
        Group {
            if popup.isDarkMode {
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center, spacing: 8) {
                        Text(popup.title)
                            .fontStyle(.body2)
                            .foregroundColor(.opacityWhite800)
                        
                        Text(popup.description)
                            .fontStyle(.label2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.opacityWhite600)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 16)
                    
                    Divider().background(.opacityWhite600)
                    
                    HStack(spacing: 0) {
                        if !popup.secondaryButtonText.isEmpty {
                            buttonSection(popup.secondaryButtonText, isPrimary: false) {
                                hidePopup()
                            }
                        }
                        
                        Divider().frame(maxHeight: .infinity).background(.opacityWhite600)
                        
                        buttonSection(popup.primaryButtonText, isPrimary: true) {
                            popupData.action()
                            hidePopup()
                        }
                    }
                    .frame(height: 44)
                }
                .background(.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 48)
            } else {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(popup.title)
                            .fontStyle(.heading2)
                            .foregroundColor(.common100)
                        
                        Text(popup.description)
                            .fontStyle(.body2)
                            .foregroundColor(.opacityWhite600)
                            .fixedSize(horizontal: false, vertical: true)
                    }
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
                .background(.common100, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            }
        }
    }
    
    @ViewBuilder
    private func buttonSection(_ text: String, isPrimary: Bool, action: @escaping ()-> Void)-> some View {
        var buttonForegroundColor: Color {
            if popupData.type.isDarkMode {
                return .opacityWhite850
            } else {
                if isPrimary {
                    return .common100
                } else {
                    return .opacityBlack300
                }
            }
        }
        var buttonBackgroundColor: Color {
            if popupData.type.isDarkMode {
                return Color.clear
            } else {
                if isPrimary {
                    return .opacityCool900
                } else {
                    return .clear
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
                .cornerRadius(16)
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
