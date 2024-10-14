//
//  Font+.swift
//  tyte
//
//  Created by 김 형석 on 9/5/24.
//

import Foundation
import SwiftUI

extension Font {
    // 인스턴스가 아닌 타입 자체에 관련된 속성이나 메서드 정의 시 사용 = 모든 인스턴스가 공유하는 값을 저장할 때 사용.
    // 앱 전체에서 일관되게 사용되어야 하는 값들은 static으로, 이렇게 안할 경우, 폰트 사용파일에서 매번 인스턴스를 생성하여 접근해야함.
    static let title1 = Font.custom("Pretendard-SemiBold", size: 36)
    static let title2 = Font.custom("Pretendard-SemiBold", size: 28)
    static let title2Prime = Font.custom("Pretendard-SemiBold", size: 26)
    static let title3 = Font.custom("Pretendard-SemiBold", size: 24)
    static let heading1 = Font.custom("Pretendard-SemiBold", size: 22)
    static let heading2 = Font.custom("Pretendard-SemiBold", size: 20)
    static let headline1 = Font.custom("Pretendard-SemiBold", size: 18)
    static let headline2 = Font.custom("Pretendard-SemiBold", size: 17)
    static let body1 = Font.custom("Pretendard-SemiBold", size: 16)
    static let body2 = Font.custom("Pretendard-SemiBold", size: 15)
    static let label1 = Font.custom("Pretendard-SemiBold", size: 14)
    static let label2 = Font.custom("Pretendard-SemiBold", size: 13)
    static let caption1 = Font.custom("Pretendard-SemiBold", size: 12)
    static let caption2 = Font.custom("Pretendard-SemiBold", size: 11)
    
    var lineSpacing: CGFloat {
        switch self {
        case .title1:
            return 48 - 36
        case .title2:
            return 38 - 28
        case .title2Prime:
            return 36 - 26
        case .title3:
            return 32 - 24
        case .heading1:
            return 30 - 22
        case .heading2:
            return 28 - 20
        case .headline1:
            return 28 - 18
        case .headline2:
            return 26 - 17
        case .body1:
            return 24 - 16
        case .body2:
            return 22 - 15
        case .label1:
            return 22 - 14
        case .label2:
            return 18 - 13
        case .caption1:
            return 16 - 12
        case .caption2:
            return 14 - 11
        default:
            return 0
        }
    }
}
