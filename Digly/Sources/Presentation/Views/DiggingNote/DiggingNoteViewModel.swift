import Foundation

@MainActor
class DiggingNoteViewModel: ObservableObject {
    @Published var ticketsWithNotes: [TicketWithNotes] = []
    @Published var isLoading: Bool = false
    @Published var expandedTicketId: Int? = nil

    private let isPreviewMode: Bool
    private let ticketUseCase: TicketUseCase
    private let noteUseCase: NoteUseCase
    private let notePreviewLimit: Int = 5

    init(
        ticketUseCase: TicketUseCase = TicketUseCase(),
        noteUseCase: NoteUseCase = NoteUseCase(),
        isPreviewMode: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    ) {
        self.ticketUseCase = ticketUseCase
        self.noteUseCase = noteUseCase
        self.isPreviewMode = isPreviewMode

        if isPreviewMode {
            ticketsWithNotes = Self.previewTicketsWithNotes
        } else {
            fetchTicketsWithNotes()
        }
    }

    func fetchTicketsWithNotes() {
        if isPreviewMode {
            return
        }

        Task {
            do {
                isLoading = true

                let ticketResponse = try await ticketUseCase.getAllTickets(page: 0)

                var ticketsWithNotesData: [TicketWithNotes] = []
                var noteFetchFailed = false

                for ticket in ticketResponse.tickets {
                    do {
                        let notesResponse = try await noteUseCase.getNotesByTicketId(
                            ticketId: ticket.id,
                            size: notePreviewLimit
                        )

                        let sortedNotes = notesResponse.notes.sorted { lhs, rhs in
                            return lhs.updatedAt > rhs.updatedAt
                        }

                        let latestNoteDate = sortedNotes.first?.updatedAt

                        let ticketWithNotes = TicketWithNotes(
                            ticket: ticket,
                            notes: sortedNotes,
                            noteCount: notesResponse.pageInfo.totalElements,
                            lastNoteDate: latestNoteDate
                        )

                        ticketsWithNotesData.append(ticketWithNotes)
                    } catch {
                        noteFetchFailed = true
                        let ticketWithNotes = TicketWithNotes(
                            ticket: ticket,
                            notes: [],
                            noteCount: 0,
                            lastNoteDate: nil
                        )
                        ticketsWithNotesData.append(ticketWithNotes)
                    }
                }

                if noteFetchFailed {
                    ToastManager.shared.show(.errorWithMessage("노트 정보를 불러오지 못했어요. 잠시 후 다시 시도해주세요."))
                }

                // Sort by most recent note date, then by ticket date
                ticketsWithNotesData.sort { ticket1, ticket2 in
                    if let date1 = ticket1.lastNoteDate, let date2 = ticket2.lastNoteDate {
                        return date1 > date2
                    } else if ticket1.lastNoteDate != nil {
                        return true
                    } else if ticket2.lastNoteDate != nil {
                        return false
                    } else {
                        return ticket1.ticket.time > ticket2.ticket.time
                    }
                }

                ticketsWithNotes = ticketsWithNotesData
                isLoading = false

            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("노트 조회"))
            }
        }
    }

    func setExpandedState(for ticketId: Int, isExpanded: Bool) {
        if isExpanded {
            expandedTicketId = ticketId
        } else if expandedTicketId == ticketId {
            expandedTicketId = nil
        }
    }

    func refreshData() {
        if isPreviewMode {
            return
        }

        fetchTicketsWithNotes()
    }
}

struct TicketWithNotes: Identifiable {
    let ticket: Ticket
    let notes: [Note]
    let noteCount: Int
    let lastNoteDate: Date?

    var id: Int { ticket.id }

    var formattedLastNoteDate: String {
        guard let lastNoteDate = lastNoteDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: lastNoteDate)
    }
}

extension DiggingNoteViewModel {
    private static var previewTicketsWithNotes: [TicketWithNotes] {
        let calendar = Calendar.current
        let now = Date()

        let firstTicket = Ticket(
            id: 1,
            name: "DIGLY LIVE TOUR",
            time: calendar.date(byAdding: .day, value: 5, to: now) ?? now,
            place: "서울 올림픽 체조경기장",
            count: 2,
            seatNumber: "A12",
            price: 132000,
            emotions: [.distressed]
        )

        let secondTicket = Ticket(
            id: 2,
            name: "뮤지컬 드림로드",
            time: calendar.date(byAdding: .day, value: -12, to: now) ?? now,
            place: "블루스퀘어 신한카드홀",
            count: 1,
            seatNumber: "B8",
            price: 88000,
            emotions: [.satisfied]
        )

        let thirdTicket = Ticket(
            id: 3,
            name: "재즈 나잇",
            time: calendar.date(byAdding: .day, value: -30, to: now) ?? now,
            place: "롯데콘서트홀",
            count: 2,
            seatNumber: nil,
            price: nil,
            emotions: [.satisfied]
        )
//
//        let firstNotes = [
//            Note(
//                id: 100,
//                title: "첫 만남",
//                content: "오프닝부터 에너지가 넘쳤고 관객 반응이 정말 뜨거웠다.",
//                createdAt: calendar.date(byAdding: .hour, value: -6, to: now),
//                updatedAt: calendar.date(byAdding: .hour, value: -2, to: now)
//            ),
//            Note(
//                id: 101,
//                title: "앙코르",
//                content: "앙코르에서 불러준 곡이 완벽한 피날레였다.",
//                createdAt: calendar.date(byAdding: .day, value: -2, to: now)
//            )
//        ]
//
//        let secondNotes = [
//            Note(
//                id: 200,
//                title: "서사 최고",
//                content: "배우들의 연기가 너무 몰입감 있어서 울컥했다.",
//                createdAt: calendar.date(byAdding: .day, value: -5, to: now)
//            ),
//            Note(
//                id: 201,
//                title: "커튼콜",
//                content: "커튼콜에서 모두가 일어나서 환호했는데 잊지 못할 순간이다.",
//                createdAt: calendar.date(byAdding: .day, value: -6, to: now)
//            ),
//            Note(
//                id: 202,
//                title: "굿즈",
//                content: "굿즈가 빨리 품절돼서 아쉬웠지만 프로그램북은 꼭 챙겼다.",
//                createdAt: calendar.date(byAdding: .day, value: -7, to: now)
//            )
//        ]
//
//        let thirdNotes = [
//            Note(
//                id: 300,
//                title: "재즈 피아노",
//                content: "피아니스트의 즉흥연주가 너무 감미로웠다.",
//                createdAt: calendar.date(byAdding: .day, value: -12, to: now)
//            )
//        ]

        return [
            TicketWithNotes(
                ticket: firstTicket,
                notes: [],
                noteCount: 4,
                lastNoteDate: calendar.date(byAdding: .day, value: -1, to: now)
            ),
            TicketWithNotes(
                ticket: secondTicket,
                notes: [],
                noteCount: 2,
                lastNoteDate: calendar.date(byAdding: .day, value: -5, to: now)
            ),
            TicketWithNotes(
                ticket: thirdTicket,
                notes: [],
                noteCount: 1,
                lastNoteDate: calendar.date(byAdding: .day, value: -12, to: now)
            )
        ]
    }
}
