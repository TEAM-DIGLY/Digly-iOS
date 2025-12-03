import Foundation

enum WithdrawalReason: String, CaseIterable {
    case notFrequentlyUsed = "자주 이용하지 않음"
    case ticketBookDissatisfaction = "티켓북 기능 불만족"
    case diggingNoteDissatisfaction = "디깅노트 기능 불만족"
    case lackOfContent = "콘텐츠 부족"
    case other = "기타 (직접입력, 최대 100자)"

    var displayText: String {
        return self.rawValue
    }
}
