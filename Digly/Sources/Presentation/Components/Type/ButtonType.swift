import SwiftUI

enum ButtonType {
    case primary
    case primaryDark
    case none
    
    var font: Font {
        switch self {
        case .primaryDark, .primary:
                .body2
        default:
                .mid
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary:
                .opacityCool900
        case .primaryDark:
                .pMid
        default: .clear
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
                .common100
        case .primaryDark:
                .common100
        default: .opacityWhite850
        }
    }
    
    var strokeColor: Color {
        switch self {
        default: .clear
        }
    }
    
    var height: CGFloat {
        switch self {
        case .primary, .primaryDark:
            48
        default:
            43
        }
    }
    
    var disabledBackgroundColor: Color {
        switch self {
        case .primary: .opacityBlack400
        case .primaryDark: .opacityWhite100
        default: .opacityBlack400
        }
    }
    
    
    var disabledForegroundColor: Color {
        switch self {
        case .primary: .common100
        case .primaryDark: .opacityWhite400
        default: .common100
        }
    }
}
