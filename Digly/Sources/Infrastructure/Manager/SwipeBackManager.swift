@MainActor
final class SwipeBackManager {
    static let shared = SwipeBackManager()
    
    private init() {}
    
    private(set) var isSwipeBackDisabled = false
    
    func updateSwipeBackDisabled(to bool: Bool) {
        print("swipeBackDisabled:", bool)
        isSwipeBackDisabled = bool
    }
}
