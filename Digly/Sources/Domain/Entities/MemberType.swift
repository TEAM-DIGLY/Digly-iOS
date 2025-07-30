import Foundation

enum MemberType: String, Codable, CaseIterable {
    case collector = "COLLECTION"
    case analyzer = "ANALYZE"
    case communicator = "COMMUNICATION"
    
    var displayName: String {
        switch self {
        case .collector:
            return "수집가"
        case .analyzer:
            return "분석가"
        case .communicator:
            return "소통가"
        }
    }
    
    var description: String {
        switch self {
        case .collector:
            return "수집하는"
        case .analyzer:
            return "분석하는"
        case .communicator:
            return "소통하는"
        }
    }
    
    var color: String {
        switch self {
        case .collector:
            return "purple"
        case .analyzer:
            return "skyBlue"
        case .communicator:
            return "yellow"
        }
    }
}