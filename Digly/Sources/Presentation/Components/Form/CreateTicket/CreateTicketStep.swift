import SwiftUI

enum CreateTicketStep: Int, CaseIterable, TicketFlowStepProtocol {
    case title = 0
    case dateTime = 1
    case venue = 2
    case ticketDetails = 3
    
    var index: Int {
        return self.rawValue
    }
    
    var screenTitle: String {
        switch self {
        case .title:
            return "어떤 극을 관람하셨나요?"
        case .dateTime:
            return "{뮤지컬제목}, 언제 관람하셨나요?"
        case .venue:
            return "{뮤지컬제목}, 어디에서 관람하셨나요?"
        case .ticketDetails:
            return "티켓 정보를 확인해주세요"
        }
    }
    
    var placeholderText: String {
        switch self {
        case .title:
            return "극 제목 입력"
        case .dateTime:
            return ""
        case .venue:
            return "관람 장소 입력"
        case .ticketDetails:
            return ""
        }
    }
    
    func getFormattedTitle(with showName: String = "") -> String {
        let title = screenTitle
        if showName.isEmpty {
            return title.replacingOccurrences(of: "{뮤지컬제목}", with: "(뮤지컬명)")
        } else {
            return title.replacingOccurrences(of: "{뮤지컬제목}", with: showName)
        }
    }
}
