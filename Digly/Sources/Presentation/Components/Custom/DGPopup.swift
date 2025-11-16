import SwiftUI

struct DGPopup: View {
    let hidePopup: () -> Void
    let type: PopupType

    private var titleColor: Color {
        if type.config.isDarkMode {
            return .opacityWhite800
        } else {
            return .opacityBlack800
        }
    }
    
    
    private var descriptionColor: Color {
        if type.config.isDarkMode {
            return .opacityWhite600
        } else {
            return .opacityBlack600
        }
    }
    
    private var buttonColor: Color {
        if type.config.isDarkMode {
            return .opacityWhite850
        } else {
            return .opacityBlack850
        }
    }
    
    private var dividerColor: Color {
        if type.config.isDarkMode {
            return .common100.opacity(0.15)
        } else {
            return .common0.opacity(0.05)
        }
    }
    
    private var backgroundColor: Color {
        if type.config.isDarkMode {
            return .bottomSheetBackground
        } else {
            return .common100
        }
    }
    
    var body: some View {
        let config = type.config
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 8) {
                Text(config.title)
                    .fontStyle(.body2)
                    .foregroundColor(titleColor)
                
                Text(config.description)
                    .fontStyle(.label2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(descriptionColor)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            
            Divider().background(dividerColor)
            
            buttonSection
        }
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 56)
    }

    @ViewBuilder
    private var buttonSection: some View {
        let config = type.config
        HStack(spacing: config.isDarkMode ? 0 : 12) {
            ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                if index > 0 {
                    Divider()
                        .frame(maxHeight: .infinity)
                        .background(dividerColor)
                }
                
                Button(action: {
                    buttonConfig.onClick()
                    hidePopup()
                }) {
                    Text(buttonConfig.text)
                        .fontStyle(.mid)
                        .foregroundColor(buttonColor)
                        .frame(maxWidth: .infinity)
                        .background(.clear)
                }
            }
        }
        .frame(height: 44)
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
                .opacity(0.3)

            DGPopup(
                hidePopup: {},
                type: .logoutWarning(onClick: {})
            )
        }
    }
}
