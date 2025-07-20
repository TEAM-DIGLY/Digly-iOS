import Foundation
import SwiftUI

struct Digly: Hashable, Identifiable {
    let id = UUID()
    let diglyType: DiglyType
    let name: String
    let role: String
    let description: String
    let color: Color
    let lightColor: Color
    
    init(diglyType: DiglyType, color: Color, lightColor: Color) {
        self.diglyType = diglyType
        self.name = diglyType.rawValue
        self.role = diglyType.role
        self.description = diglyType.description
        self.color = color
        self.lightColor = lightColor
    }
    
    static let data: [Digly] = [
        Digly(
            diglyType: .collector,
            color: .pDefault,
            lightColor: .pLight
        ),
        Digly(
            diglyType: .analyst,
            color: .sbDefault,
            lightColor: .sbLight
        ),
        Digly(
            diglyType: .communicator,
            color: .yDefault,
            lightColor: .yLight
        )
    ]
}
