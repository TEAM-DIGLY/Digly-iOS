import SwiftUI

struct ButtonConfig {
    let text: String
    let type: ButtonType
    let onClick: () -> Void
    let disabled: Bool
    
    init(
        text: String,
        type: ButtonType = .primary,
        onClick: @escaping () -> Void = {},
        disabled: Bool = false
    ) {
        self.text = text
        self.type = type
        self.onClick = onClick
        self.disabled = disabled
    }
}
