import Foundation

struct Alarm: Identifiable {
    let id: Int
    let title: String
    let content: String
    let createdAt: Date
}

struct NotificationsResult {
    let notifications: [Alarm]
    let pageInfo: Pagination
}

extension Alarm {
    static let dummy: Alarm = .init(
        id: 1,
        title: "새로운 캠페인 소식",
        content: "관심 등록한 캠페인이 시작됐어요. 지금 확인해 보세요!",
        createdAt: Date().addingTimeInterval(-3600)
    )
    
    static let dummies: [Alarm] = [
        .dummy,
        .init(
            id: 2,
            title: "지원서 제출 완료",
            content: "제출하신 지원서가 접수되었어요.",
            createdAt: Date().addingTimeInterval(-10800)
        ),
        .init(
            id: 3,
            title: "알림 설정 변경",
            content: "알림 설정이 정상적으로 저장되었습니다.",
            createdAt: Date().addingTimeInterval(-86400)
        )
    ]
}
