import Foundation

extension Date {
    /// Date를 "M월 d일" 형식으로 포맷팅
    /// - Returns: "5월 29일" 형식의 문자열
    func toKoreanDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// Date를 "yyyy. MM. dd  HH:mm" 형식으로 포맷팅 (문의 날짜용)
    /// - Returns: "2025. 06. 09  18:45" 형식의 문자열
    func toInquiryDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd  HH:mm"
        return formatter.string(from: self)
    }
    
    /// 현재 시간과의 차이를 한국어로 표현
    /// - Returns: "방금", "14분 전", "2시간 전", "3일 전", "2024.12.25" 등의 문자열
    func timeAgoString() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        let seconds = Int(timeInterval)
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        
        // ~59초: 방금
        if seconds < 60 {
            return "방금"
        }
        // 1분 ~ 59분: N분 전
        else if minutes < 60 {
            return "\(minutes)분 전"
        }
        // 1시간 ~ 23시간 59분: N시간 전
        else if hours < 24 {
            return "\(hours)시간 전"
        }
        // 24시간 ~ 7일: N일 전
        else if days <= 7 {
            return "\(days)일 전"
        }
        // 8일 ~ : yyyy.mm.dd
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: self)
        }
    }
}
