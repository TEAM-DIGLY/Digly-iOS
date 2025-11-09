import Foundation
import SwiftUI

extension Font {
    // Title
    static let title1 = Font.custom("Pretendard-SemiBold", size: 36)
    static let title2 = Font.custom("Pretendard-SemiBold", size: 28)
    static let title2_ = Font.custom("Pretendard-SemiBold", size: 26)
    static let title3 = Font.custom("Pretendard-SemiBold", size: 24)

    // Heading
    static let heading1 = Font.custom("Pretendard-SemiBold", size: 22)
    static let heading2 = Font.custom("Pretendard-SemiBold", size: 20)

    // Headline
    static let headline1 = Font.custom("Pretendard-SemiBold", size: 18)
    static let headline2 = Font.custom("Pretendard-SemiBold", size: 17)

    // Body
    static let body1 = Font.custom("Pretendard-SemiBold", size: 16)
    static let body2 = Font.custom("Pretendard-SemiBold", size: 15)

    // Label
    static let label1 = Font.custom("Pretendard-SemiBold", size: 14)
    static let label1Med = Font.custom("Pretendard-Medium", size: 14)
    static let label2 = Font.custom("Pretendard-SemiBold", size: 13)
    static let label2Med = Font.custom("Pretendard-Medium", size: 13)

    // Caption
    static let caption1 = Font.custom("Pretendard-SemiBold", size: 12)
    static let caption2 = Font.custom("Pretendard-SemiBold", size: 11)

    // Popup
    static let top = Font.custom("Pretendard-SemiBold", size: 16)
    static let mid = Font.custom("Pretendard-SemiBold", size: 13)
    static let smallBold = Font.custom("Pretendard-SemiBold", size: 11)
    static let smallMid = Font.custom("Pretendard-Medium", size: 11)
    static let smallLine = Font.custom("Pretendard-Medium", size: 11)
    static let tiny = Font.custom("Pretendard-Medium", size: 9)
    
    var lineSpacing: CGFloat {
        switch self {
        // Title
        case .title1:
            return 48 - 36  // 12
        case .title2:
            return 38 - 28  // 10
        case .title2_:
            return 36 - 26  // 10
        case .title3:
            return 32 - 24  // 8

        // Heading
        case .heading1:
            return 30 - 22  // 8
        case .heading2:
            return 28 - 20  // 8

        // Headline
        case .headline1:
            return 28 - 18  // 10
        case .headline2:
            return 26 - 17  // 9

        // Body
        case .body1:
            return 24 - 16  // 8
        case .body2:
            return 22 - 15  // 7

        // Label
        case .label1:
            return 21 - 14  // 7
        case .label1Med:
            return 21 - 14  // 7
        case .label2:
            return 18 - 13  // 5
        case .label2Med:
            return 18 - 13  // 5

        // Caption
        case .caption1:
            return 16 - 12  // 4
        case .caption2:
            return 14 - 11  // 3

        // Popup
        case .top:
            return 0  // normal line height
        case .mid:
            return 0  // line height auto
        case .smallBold:
            return 0  // no specific line height
        case .smallMid:
            return 0  // no specific line height
        case .smallLine:
            return 0  // no specific line height
        case .tiny:
            return 0  // no specific line height

        default:
            return 0
        }
    }
}
