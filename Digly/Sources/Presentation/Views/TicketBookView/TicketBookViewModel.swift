import Foundation
import Combine
import SwiftUI

// MARK: - Ticket Model
struct TicketModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let date: String
    let location: String
    let number: Int
    let primaryColor: Color
    let secondaryColor: Color
    
    // 상세 정보
    let userName: String
    let watchDate: String
    let watchNumber: Int
    let venue: String
    let seatInfo: String
    let price: String
    
    // 샘플 데이터
    static let sampleData: [TicketModel] = [
        TicketModel(
            title: "ALADDIN",
            subtitle: "The Musical",
            date: "2024.01.19",
            location: "샤롯데씨어터",
            number: 1,
            primaryColor: .green,
            secondaryColor: .orange,
            userName: "Username",
            watchDate: "2024년 01월 19일 (금) 19:30",
            watchNumber: 1,
            venue: "샤롯데씨어터",
            seatInfo: "1층 15열 8번",
            price: "132,000원"
        ),
        TicketModel(
            title: "시라노",
            subtitle: nil,
            date: "2023.10.04",
            location: "예술의전당",
            number: 3,
            primaryColor: .blue,
            secondaryColor: .purple,
            userName: "Username",
            watchDate: "2023년 10월 04일 (수) 20:00",
            watchNumber: 3,
            venue: "예술의전당",
            seatInfo: "2층 8열 12번",
            price: "88,000원"
        ),
        TicketModel(
            title: "캣츠 내한공연",
            subtitle: "50주년",
            date: "2025.03.12",
            location: "예술의전당",
            number: 2,
            primaryColor: .purple,
            secondaryColor: .yellow,
            userName: "Username",
            watchDate: "2025년 03월 12일 (수) 19:30",
            watchNumber: 2,
            venue: "예술의전당",
            seatInfo: "1층 20열 5번",
            price: "156,000원"
        ),
        TicketModel(
            title: "웃는남자",
            subtitle: nil,
            date: "2024.12.25",
            location: "블루스퀘어",
            number: 4,
            primaryColor: .blue,
            secondaryColor: .indigo,
            userName: "Username",
            watchDate: "2024년 12월 25일 (수) 14:00",
            watchNumber: 4,
            venue: "블루스퀘어",
            seatInfo: "1층 12열 23번",
            price: "112,000원"
        )
    ]
}

class TicketBookViewModel: ObservableObject {
    @Published var username: String = "Username"
    @Published var totalTickets: Int = 110
    @Published var tickets: [TicketModel] = TicketModel.sampleData
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // 티켓 개수 자동 업데이트
        $tickets
            .map { $0.count }
            .assign(to: \.totalTickets, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Ticket Management
    func addTicket(_ ticket: TicketModel) {
        tickets.append(ticket)
    }
    
    func removeTicket(at indexSet: IndexSet) {
        tickets.remove(atOffsets: indexSet)
    }
    
    // MARK: - Actions
    func addTicketAction() {
        // 티켓 추가 로직
        print("티켓 추가 액션")
    }
    
    func filterAction() {
        // 필터 액션
        print("필터 액션")
    }
    
    func searchAction() {
        // 검색 액션
        print("검색 액션")
    }
    
    func downloadTicket() {
        // 티켓 다운로드 액션
        print("티켓 다운로드")
    }
    
    func showTicketDetail() {
        // 티켓 상세보기 액션
        print("티켓 상세보기")
    }
    
    func goToDiggingNote() {
        // 디깅노트로 이동 액션
        print("디깅노트로 이동")
    }
}
