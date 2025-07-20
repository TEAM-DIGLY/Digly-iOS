import Foundation

// MARK: - BaseRoute Protocol
protocol BaseRoute: Hashable {
    var id: String { get }
    var disableSwipeBack: Bool { get }
}

// MARK: - BaseRoute Protocol Extensions
extension BaseRoute {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// 기본 동등성 구현
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
