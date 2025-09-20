import Foundation

struct CreateTicketFormData {
    var showName: String = ""
    var date: Date? = nil
    var time: Date? = nil
    var place: String = ""
    var count: Int = 0
    var seatNumber: String = ""
    var price: Int = 0
    
    func value(for field: CreateTicketStep) -> String {
        switch field {
        case .title:
            showName
        case .dateTime:
            ""
        case .venue:
            place
        case .ticketDetails:
            ""
        }
    }
    
    mutating func setValue(_ value: String, for field: CreateTicketStep) {
        switch field {
        case .title:
            showName = value
        case .dateTime:
            break // Date/time는 별도 메서드로 처리
        case .venue:
            place = value
        case .ticketDetails:
            break // 최종 단계는 별도 처리
        }
    }
    
    mutating func setPerformanceDateTime(_ dateTime: Date) {
        date = dateTime
        time = dateTime
    }
    
    mutating func updateDate(from _date: Date) {
        date = _date
        if time == nil {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: _date)
            components.hour = 15
            components.minute = 0
            time = Calendar.current.date(from: components)
        }
    }
    
    mutating func updateTime(from _time: Date) {
        time = _time
        // 날짜가 설정되지 않았다면 기본 날짜(오늘)로 설정
        if date == nil {
            date = Date()
        }
    }
    
    mutating func setSeatNumber(_ number: String) {
        seatNumber = number
    }
    
    mutating func setCount(_ number: Int) {
        count = number
    }
    
    mutating func setTicketPrice(_ _price: Int) {
        price = _price
    }
    
    var isBasicInfoComplete: Bool {
        !showName.isEmpty &&
        !place.isEmpty &&
        date != nil &&
        time != nil
    }
    
    /// API 호출시 사용할 수 있도록 날짜와 시간을 합친 Date 객체
    var combinedPerformanceDateTime: Date? {
        guard let date = date, let time = time else {
            return nil
        }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = dateComponents
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents)
    }
}
