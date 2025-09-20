import SwiftUI

@MainActor
final class TicketFlowRouter: BaseRouter {
    typealias RouteType = TicketFlowRoute
    @Published var path = NavigationPath()
    
    // Completion callback when ticket flow is finished
    var onFlowCompleted: (() -> Void)?
    
    init(onFlowCompleted: (() -> Void)? = nil) {
        self.onFlowCompleted = onFlowCompleted
    }
    
    func completeFlow() {
        reset()
        onFlowCompleted?()
    }
}