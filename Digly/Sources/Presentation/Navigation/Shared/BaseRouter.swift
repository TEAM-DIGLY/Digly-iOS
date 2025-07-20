import SwiftUI
import Combine

// MARK: - Base Router Protocol
@MainActor
protocol BaseRouter: ObservableObject {
    associatedtype RouteType: BaseRoute
    var path: NavigationPath { get set }
    
    func push(to route: RouteType)
    func pop()
    func reset()
    func popTo(count: Int)
    func replace(with route: RouteType)
}

// MARK: - Base Router Implementation
extension BaseRouter {
    func push(to route: RouteType) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
    
    func popTo(count: Int) {
        guard count > 0, count <= path.count else { return }
        path.removeLast(count)
    }
    
    func replace(with route: RouteType) {
        path = NavigationPath()
        path.append(route)
    }
} 