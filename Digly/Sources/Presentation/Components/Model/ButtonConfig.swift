import SwiftUI

/// - note: Popup 및 Toast에서 버튼의 속성을 담기위한 구조체입니다.
struct ButtonConfig {
    let text: String
    let onClick: () -> Void
    let disabled: Bool
    
    init(
        text: String,
        onClick: @escaping () -> Void = {},
        disabled: Bool = false
    ) {
        self.text = text
        self.onClick = onClick
        self.disabled = disabled
    }
}
