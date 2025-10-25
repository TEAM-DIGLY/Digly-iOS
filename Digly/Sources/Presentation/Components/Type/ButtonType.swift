import SwiftUI

enum ButtonType {
    case primary
    case primaryDark
    
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
        case .primary: .neutral900
        case .primaryDark: .pMid
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary: .common100
        case .primaryDark: .common100
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .primary: .clear
        case .primaryDark: .clear
        }
    }
    
    var height: CGFloat {
        54
    }
    
    var disabledBackgroundColor: Color {
        switch self {
        case .primary: .opacityBlack400
        case .primaryDark: .opacityBlack600
        }
    }
    
    
    var disabledForegroundColor: Color {
        switch self {
        case .primary: .common100
        case .primaryDark: .opacityWhite400
        }
    }
}
