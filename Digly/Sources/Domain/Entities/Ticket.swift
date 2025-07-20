import SwiftUI

struct Ticket: Identifiable {
    let id: String
    let title: String
    var subTitle: String? = nil
    let number: Int
    let date: String
    let theater: String
    let status: TicketStatus
    let imageColors: [Color]
}

public enum TicketStatus {
    case ongoing
    case upcoming
    case completed
    case pending
}
