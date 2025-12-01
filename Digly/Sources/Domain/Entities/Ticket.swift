import SwiftUI
import Foundation

struct Ticket: Identifiable {
    let id: Int
    let name: String
    let time: Date
    let place: String
    let count: Int
    let seatNumber: String?
    let price: Int?
    let emotions: [Emotion]
    var notes: [Note]?
    
    
    init(id: Int, name: String, time: Date, place: String, count: Int, seatNumber: String?, price: Int?, emotions: [Emotion], notes: [Note]? = nil) {
        self.id = id
        self.name = name
        self.time = time
        self.place = place
        self.count = count
        self.seatNumber = seatNumber
        self.price = price
        self.emotions = emotions
        self.notes = notes
    }
    
    static let dummy: Ticket = Ticket(
        id: 1,
        name: "프랑켄슈타인",
        time: Date(),
        place: "블루스퀘어 신한카드홀",
        count: 24,
        seatNumber: "A4",
        price: 20000,
        emotions: [.glad, .excited],
        notes: [
            Note(
                id: 1,
                contents: [
                    NoteContent(question: "가장 좋았던 점", answer: "배우들의 에너지와 무대 연출"),
                    NoteContent(question: "기억하고 싶은 순간", answer: "2막 클라이맥스 넘버")
                ],
                updatedAt: Date()
            )
        ]
    )

    static let dummyList: [Ticket] = [
        .dummy,
        Ticket(
            id: 2,
            name: "시카고",
            time: Date().addingTimeInterval(60 * 60 * 24 * 7),
            place: "디큐브 링크아트센터",
            count: 18,
            seatNumber: "B12",
            price: 150000,
            emotions: [.satisfied, .relaxed],
            notes: [
                Note(
                    id: 2,
                    contents: [
                        NoteContent(question: "함께 간 사람", answer: "친구"),
                        NoteContent(question: "한 줄 평", answer: "재즈 넘버가 귀에 쏙 들어온다")
                    ],
                    updatedAt: Date().addingTimeInterval(-60 * 60 * 12)
                )
            ]
        ),
        Ticket(
            id: 3,
            name: "라이온킹",
            time: Date().addingTimeInterval(60 * 60 * 24 * 21),
            place: "예술의전당 오페라극장",
            count: 30,
            seatNumber: "C3",
            price: 99000,
            emotions: [.excited, .glad],
            notes: []
        )
    ]
}


struct PageInfo: Codable {
    let pageNum: Int32
    let pageSize: Int32
    let totalElements: Int
    let totalPages: Int
}
