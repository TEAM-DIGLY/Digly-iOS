import Foundation

struct Note: Identifiable {
    let id: Int
    let contents: [NoteContent]
    let updatedAt: Date
    
    static let dummyWithQuestion: Note = Note(
        id: 1,
        contents: [
            NoteContent(question: "함께 간 사람", answer: "친구"),
            NoteContent(question: "기억하고 싶은 순간", answer: "1막 마지막 넘버에서의 에너지"),
            NoteContent(question: "다음에 다시 보고 싶은지", answer: "다음 시즌에도 꼭 보고 싶다")
        ],
        updatedAt: Date()
    )
    static let dummy: Note = Note(
        id: 1,
        contents: [
            NoteContent(question: "", answer: "1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지1막 마지막 넘버에서의 에너지")
        ],
        updatedAt: Date()
    )
    
    static let dummyList: [Note] = [
        .dummy,
        Note(
            id: 2,
            contents: [
                NoteContent(question: "좌석", answer: "A구역 6열"),
                NoteContent(question: "배우 케미", answer: "메인 캐스트 조합이 완벽했다"),
                NoteContent(question: "한줄평", answer: "음악과 조명 연출이 공연을 더 풍성하게 만들었다")
            ],
            updatedAt: Date().addingTimeInterval(-60 * 60 * 5)
        ),
        Note(
            id: 3,
            contents: [
                NoteContent(question: "예매 경로", answer: "공식 예매처"),
                NoteContent(question: "굿즈", answer: "포스터와 프로그램북 구매"),
                NoteContent(question: "다음에 개선되면 좋을 점", answer: "인터미션 대기 동선 개선 필요")
            ],
            updatedAt: Date().addingTimeInterval(-60 * 60 * 24 * 2)
        )
    ]
}

struct NoteContent: Codable {
    let question: String
    let answer: String
}
