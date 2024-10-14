//
//  View+.swift
//  digly
//
//  Created by 김 형석 on 10/14/24.
//
import SwiftUI

extension View {
    func fontStyle(_ font: Font) -> some View {
        self.font(font)
            .lineSpacing(CGFloat(font.lineSpacing))
    }
}
