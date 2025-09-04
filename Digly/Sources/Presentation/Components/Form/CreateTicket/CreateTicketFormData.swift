import Foundation

struct CreateTicketFormData {
    var showName: String = ""
    var performanceDate: Date? = nil
    var performanceTime: Date? = nil
    var venueName: String = ""
    var seatNumber: String = "1"
    var seatLocation: String = ""
    var ticketPrice: String = ""
    
    func value(for field: CreateTicketStep) -> String {
        switch field {
        case .title:
            showName
        case .dateTime:
            ""
        case .venue:
            venueName
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
            venueName = value
        case .ticketDetails:
            break // 최종 단계는 별도 처리
        }
    }
    
    mutating func setPerformanceDateTime(_ dateTime: Date) {
        performanceDate = dateTime
        performanceTime = dateTime
    }
    
    mutating func updateDateComponent(from date: Date) {
        performanceDate = date
        // 시간이 설정되지 않았다면 기본 시간(현재 시간)으로 설정
        if performanceTime == nil {
            performanceTime = Date()
        }
    }
    
    mutating func updateTimeComponent(from time: Date) {
        performanceTime = time
        // 날짜가 설정되지 않았다면 기본 날짜(오늘)로 설정
        if performanceDate == nil {
            performanceDate = Date()
        }
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
    
    var isBasicInfoComplete: Bool {
        !showName.isEmpty &&
        !venueName.isEmpty &&
        performanceDate != nil &&
        performanceTime != nil
    }
    
    /// API 호출시 사용할 수 있도록 날짜와 시간을 합친 Date 객체
    var combinedPerformanceDateTime: Date? {
        guard let date = performanceDate, let time = performanceTime else {
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
