import SwiftUI

enum PopupType {
    case updateMandatory(onClick: () -> Void)
    case updateOptional(onClick: () -> Void)
    case toggleGuideOff(onClick: () -> Void)
    case toggleGuideOn(onClick: () -> Void)
    case logoutWarning(onClick: () -> Void)
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
                    ButtonConfig(text: "업데이트 하기"){ onClick() }
                ]
            )
        case .updateOptional(let onClick):
            PopupConfig(
                title: "휴머니아 새 버전 출시!",
                description: "서비스를 이용하기 위해\n업데이트가 필요해요",
                isOptional: true,
                isDarkMode: false,
                buttons: [
                    ButtonConfig(text: "업데이트 하기"){ onClick() },
                    ButtonConfig(text: "취소") {}
                ]
            )
        case .toggleGuideOff(let onClick):
            PopupConfig(
                title: "가이드 설정",
                description: "가이드를 끄면 작성한 노트가\n초기화 됩니다. 가이드를 사용할까요?",
                isOptional: true,
                isDarkMode: true,
                buttons: [
                    ButtonConfig(text: "취소") {},
                    ButtonConfig(text: "끄기") { onClick() }
                ]
            )
        case .toggleGuideOn(let onClick):
            PopupConfig(
                title: "가이드 설정",
                description: "가이드를 사용할 시 작성한 노트가\n초기화 됩니다. 가이드를 사용할까요?",
                isOptional: true,
                isDarkMode: true,
                buttons: [
                    ButtonConfig(text: "취소") {},
                    ButtonConfig(text: "사용") { onClick() }
                ]
            )
        case .logoutWarning(let onClick):
            PopupConfig(
                title: "정말 로그아웃 할까요?",
                description: "처음 로그인 화면으로 돌아갈게요.",
                isOptional: true,
                isDarkMode: false,
                buttons: [
                    ButtonConfig(text: "취소") {},
                    ButtonConfig(text: "로그아웃") { onClick() }
                ]
            )
        case .custom:
            PopupConfig(
                title: "",
                description: "",
                isOptional: false,
                isDarkMode: false,
                buttons: []
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

    init(
        title: String,
        description: String,
        isOptional: Bool = true,
        isDarkMode: Bool = true,
        buttons: [ButtonConfig],
    ) {
        self.title = title
        self.description = description
        self.isOptional = isOptional
        self.isDarkMode = isDarkMode
        self.buttons = buttons
    }
}
