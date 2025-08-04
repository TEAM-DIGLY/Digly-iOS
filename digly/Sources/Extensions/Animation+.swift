import SwiftUI

extension Animation {
    struct Duration {
        static let fast: Double = 0.1
        static let mediumFast: Double = 0.2
        static let medium: Double = 0.3
        static let slow: Double = 0.7
    }
    
    static var fastEaseOut: Animation {
        easeOut(duration: Duration.fast)
    }
    
    static var mediumEaseOut: Animation {
        easeOut(duration: Duration.medium)
    }
    
    // MARK: - EaseInOut
    static var fastEaseInOut: Animation {
        easeInOut(duration: Duration.fast)
    }
    
    static var mediumEaseInOut: Animation {
        easeInOut(duration: Duration.medium)
    }
    
    static var longEaseInOut: Animation {
        easeInOut(duration: Duration.slow)
    }
    
    // MARK: - Spring
    static var fastSpring: Animation {
        spring(duration: Duration.fast)
    }
    
    static var mediumFastSpring: Animation {
        spring(duration: Duration.mediumFast)
    }
    
    static var mediumSpring: Animation {
        spring(duration: Duration.medium)
    }
}
