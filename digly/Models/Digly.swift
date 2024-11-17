import Foundation
import SwiftUI

struct DiglyType: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let description: String
    let color: Color
    let lightColor: Color
    
    static let data: [DiglyType] = [
        DiglyType(
            name: "collector",
            role: "수집",
            description: "마음에 드는 굿즈들을",
            color: Color.p50,
            lightColor: Color.p00
        ),
        DiglyType(
            name: "analyst",
            role: "분석",
            description: "관람한 문화생활을",
            color: Color.b50,
            lightColor: Color.b00
        ),
        DiglyType(
            name: "communicator",
            role: "소통",
            description: "다양한 사람들과 함께",
            color: Color.y50,
            lightColor: Color.y00
        )
    ]
}