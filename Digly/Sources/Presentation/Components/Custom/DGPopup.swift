import SwiftUI

struct DGPopup: View {
    let hidePopup: () -> Void
    let type: PopupType

    var body: some View {
        let config = type.config

        Group {
            if config.isDarkMode {
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center, spacing: 8) {
                        Text(config.title)
                            .fontStyle(.body2)
                            .foregroundColor(.opacityWhite800)

                        Text(config.description)
                            .fontStyle(.label2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.opacityWhite600)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 16)

                    Divider().background(.opacityWhite600)

                    buttonSection
                }
                .background(.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 56)
            } else {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(config.title)
                            .fontStyle(.heading2)
                            .foregroundColor(.common100)

                        Text(config.description)
                            .fontStyle(.body2)
                            .foregroundColor(.opacityWhite600)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.bottom, 24)

                    buttonSection
                }
                .padding(24)
                .background(.common100, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            }
        }
    }

    @ViewBuilder
    private var buttonSection: some View {
        let config = type.config

        switch config.buttonLayout {
        case .horizontal:
            HStack(spacing: config.isDarkMode ? 0 : 12) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                    if config.isDarkMode {
                        if index > 0 {
                            Divider().frame(maxHeight: .infinity).background(.opacityWhite600)
                        }
                        darkModeButton(buttonConfig)
                    } else {
                        lightModeButton(buttonConfig)
                    }
                }
            }
            .frame(height: config.isDarkMode ? 44 : nil)
        case .vertical:
            VStack(spacing: config.isDarkMode ? 0 : 12) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                    if config.isDarkMode {
                        if index > 0 {
                            Divider().background(.opacityWhite600)
                        }
                        darkModeButton(buttonConfig)
                            .frame(height: 44)
                    } else {
                        lightModeButton(buttonConfig)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func darkModeButton(_ buttonConfig: ButtonConfig) -> some View {
        Button(action: {
            buttonConfig.onClick()
            hidePopup()
        }) {
            Text(buttonConfig.text)
                .fontStyle(.label2)
                .foregroundColor(.opacityWhite850)
                .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func lightModeButton(_ buttonConfig: ButtonConfig) -> some View {
        Button(action: {
            buttonConfig.onClick()
            hidePopup()
        }) {
            Text(buttonConfig.text)
                .fontStyle(.body1)
                .foregroundColor(buttonConfig.type == .primary ? .common100 : .opacityBlack300)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(buttonConfig.type == .primary ? .opacityCool900 : .clear)
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
                .opacity(0.3)

            DGPopup(
                hidePopup: {},
                type: .toggleGuideOff(onClick: {})
            )
        }
    }
}
