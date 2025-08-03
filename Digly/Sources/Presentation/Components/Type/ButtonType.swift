import SwiftUI

enum ButtonType {
    case primary
    
    var font: Font {
        switch self {
        case .primary:
                .body1
        default:
                .body1
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary: .neutral5
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary: .common100
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .primary: .clear
        }
    }
    
    var height: CGFloat {
        56
    }
    
    var disabledBackgroundColor: Color { .opacity55 }
    var disabledForegroundColor: Color { .common100 }
}
