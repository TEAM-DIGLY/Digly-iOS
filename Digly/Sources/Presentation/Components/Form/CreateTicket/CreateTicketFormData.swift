import Foundation

struct CreateTicketFormData {
    var showName: String = ""
    var selectedDate: String = "관람 일자"
    var selectedTime: String = "관람 시간"
    var venueName: String = ""
    var seatNumber: String = "1"
    var seatLocation: String = ""
    var ticketPrice: String = ""
    
    func value(for field: CreateTicketStep) -> String {
        switch field {
        case .title:
            return showName
        case .dateTime:
            return "\(selectedDate) \(selectedTime)"
        case .venue:
            return venueName
        case .ticketDetails:
            return ""
        }
    }
    
    mutating func setValue(_ value: String, for field: CreateTicketStep) {
        switch field {
        case .title:
            showName = value
        case .dateTime:
            break // Date/time는 별도 메서드로 처리
        case .venue:
            venueName = value
        case .ticketDetails:
            break // 최종 단계는 별도 처리
        }
    }
    
    mutating func setDate(_ date: String) {
        selectedDate = date
    }
    
    mutating func setTime(_ time: String) {
        selectedTime = time
    }
    
    mutating func setSeatNumber(_ number: String) {
        seatNumber = number
    }
    
    mutating func setSeatLocation(_ location: String) {
        seatLocation = location
    }
    
    mutating func setTicketPrice(_ price: String) {
        ticketPrice = price
    }
    
    // Validation helpers
    var isDateTimeValid: Bool {
        return selectedDate != "관람 일자" && selectedTime != "관람 시간" &&
               !selectedDate.isEmpty && !selectedTime.isEmpty
    }
    
    var isBasicInfoComplete: Bool {
        return !showName.isEmpty && !venueName.isEmpty && isDateTimeValid
    }
}
