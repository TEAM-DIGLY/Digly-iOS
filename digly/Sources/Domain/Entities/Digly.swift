import Foundation
import SwiftUI

import Foundation
import SwiftUI

struct Digly: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let description: String
    let color: Color
    let lightColor: Color
    
    static let data: [Digly] = [
        Digly(
            name: "collector",
            role: "수집",
            description: "마음에 드는 굿즈들을",
            color: .pDefault,
            lightColor: .pLight
        ),
        Digly(
            name: "analyst",
            role: "분석",
            description: "관람한 문화생활을",
            color: .sbDefault,
            lightColor: .sbLight
        ),
        Digly(
            name: "communicator",
            role: "소통",
            description: "다양한 사람들과 함께",
            color: .yDefault,
            lightColor: .yLight
        )
    ]
}
