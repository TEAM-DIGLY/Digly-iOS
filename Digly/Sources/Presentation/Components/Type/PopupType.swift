import SwiftUI

enum PopupType {
    case updateMandatory(onClick: () -> Void)
    case updateOptional(onClick: () -> Void)
    case toggleGuideOff(onClick: () -> Void)
    case toggleGuideOn(onClick: () -> Void)
    case custom(any View)

    var config: PopupConfig {
        switch self {
        case .updateMandatory(let onClick):
            PopupConfig(
                title: "휴머니아 새 버전 출시!",
                description: "서비스를 이용하기 위해\n업데이트가 필요해요",
                isOptional: false,
                isDarkMode: false,
                buttons: [
                    ButtonConfig(text: "업데이트 하기", type: .primary, onClick: onClick)
                ],
                buttonLayout: .vertical
            )
        case .updateOptional(let onClick):
            PopupConfig(
                title: "휴머니아 새 버전 출시!",
                description: "서비스를 이용하기 위해\n업데이트가 필요해요",
                isOptional: true,
                isDarkMode: false,
                buttons: [
                    ButtonConfig(text: "업데이트 하기", type: .primary, onClick: onClick),
                    ButtonConfig(text: "취소", type: .none, onClick: {})
                ],
                buttonLayout: .vertical
            )
        case .toggleGuideOff(let onClick):
            PopupConfig(
                title: "가이드 설정",
                description: "가이드를 끄면 작성한 노트가\n초기화 됩니다. 가이드를 사용할까요?",
                isOptional: true,
                isDarkMode: true,
                buttons: [
                    ButtonConfig(text: "취소", type: .none, onClick: {}),
                    ButtonConfig(text: "끄기", type: .primary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .toggleGuideOn(let onClick):
            PopupConfig(
                title: "가이드 설정",
                description: "가이드를 사용할 시 작성한 노트가\n초기화 됩니다. 가이드를 사용할까요?",
                isOptional: true,
                isDarkMode: true,
                buttons: [
                    ButtonConfig(text: "취소", type: .none, onClick: {}),
                    ButtonConfig(text: "사용", type: .primary, onClick: onClick),
                ],
                buttonLayout: .horizontal
            )
        case .custom:
            PopupConfig(
                title: "",
                description: "",
                isOptional: false,
                isDarkMode: false,
                buttons: [],
                buttonLayout: .vertical
            )
        }
    }
}

struct PopupConfig {
    let title: String
    let description: String
    let isOptional: Bool
    let isDarkMode: Bool
    let buttons: [ButtonConfig]
    let buttonLayout: ButtonLayout

    init(
        title: String,
        description: String,
        isOptional: Bool = true,
        isDarkMode: Bool = true,
        buttons: [ButtonConfig],
        buttonLayout: ButtonLayout = .vertical
    ) {
        self.title = title
        self.description = description
        self.isOptional = isOptional
        self.isDarkMode = isDarkMode
        self.buttons = buttons
        self.buttonLayout = buttonLayout
    }
}

enum ButtonLayout {
    case vertical
    case horizontal
}
