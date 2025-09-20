import Foundation

extension String {
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    // e.g. 2025-09-24T06:05:00 (no timezone)
    private static let dateTimeNoTZFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    private static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    /// "yyyy-MM-dd", "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss"(no TZ) 형식을 Date로 변환
    /// - Returns: Date 객체, 변환 실패 시 Date()
    func toDate() -> Date {
        // 먼저 yyyy-MM-dd 형식 시도
        if let date = String.dateOnlyFormatter.date(from: self) {
            return date
        }
        
        // ISO8601 형식 시도
        if let date = String.iso8601Formatter.date(from: self) {
            return date
        }
        
        // ISO8601 without timezone (e.g., 2025-09-24T06:05:00)
        if let date = String.dateTimeNoTZFormatter.date(from: self) {
            return date
        }
        
        print("toDate 메서드 실패: \(self)")
        return Date()
    }
}
