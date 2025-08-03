import Foundation
import SwiftUI

public enum DiglyType: String, CaseIterable, Codable {
    case collector = "collector"
    case analyst = "analyst"
    case communicator = "communicator"
    
    var displayName: String {
        switch self {
        case .collector:
            return "수집가"
        case .analyst:
            return "분석가"
        case .communicator:
            return "소통가"
        }
    }
    
    var subColor: Color {
        switch self {
        case .collector:
            return .pLight
        case .analyst:
            return .sbLight
        case .communicator:
            return .yLight
        }
    }
    
    var description: String {
        switch self {
        case .collector:
            return "마음에 드는 굿즈들을"
        case .analyst:
            return "관람한 문화생활을"
        case .communicator:
            return "다양한 사람들과 함께"
        }
    }
    
    var verb: String {
        switch self {
        case .collector:
            return "수집하는"
        case .analyst:
            return "분석하는"
        case .communicator:
            return "소통하는"
        }
    }
    
    var role: String {
        switch self {
        case .collector:
            return "수집"
        case .analyst:
            return "분석"
        case .communicator:
            return "소통"
        }
    }
    
    func toMemberType() -> MemberType {
        switch self {
        case .collector:
            return .collector
        case .analyst:
            return .analyzer
        case .communicator:
            return .communicator
        }
    }

} 
