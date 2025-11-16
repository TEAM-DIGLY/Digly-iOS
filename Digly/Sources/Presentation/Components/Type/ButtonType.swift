import SwiftUI

enum ButtonType {
    case primary
    case primaryDark
    case none
    
    var font: Font {
        switch self {
        default:
                .mid
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primaryDark:
                .opacityCool900
        default: .clear
        }
    }
    
    var foregroundColor: Color {
        switch self {
        default: .opacityWhite850
        }
    }
    
    var strokeColor: Color {
        switch self {
        default: .clear
        }
    }
    
    var height: CGFloat {
        43
    }
    
    var disabledBackgroundColor: Color {
        switch self {
        case .primary: .opacityBlack400
        case .primaryDark: .opacityBlack600
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
