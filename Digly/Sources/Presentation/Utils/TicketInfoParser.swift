import Foundation

struct TicketInfoParser {
    
    enum ParsingError: LocalizedError {
        case noDataFound
        case invalidFormat
        case missingRequiredFields
        
        var errorDescription: String? {
            switch self {
            case .noDataFound:
                return "티켓 정보를 찾을 수 없습니다."
            case .invalidFormat:
                return "올바르지 않은 형식입니다."
            case .missingRequiredFields:
                return "필수 정보가 누락되었습니다."
            }
        }
    }
    
    func parseTicketInfo(from text: String) -> Result<CreateTicketFormData, ParsingError> {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .failure(.noDataFound)
        }
        
        var ticketData = CreateTicketFormData()
        
        if let showName = extractShowName(from: text) {
            ticketData.showName = showName
        }
        
        if let (date, time) = extractDateTime(from: text) {
            ticketData.date = date
            ticketData.time = time
        }
        
        if let venue = extractVenue(from: text) {
            ticketData.place = venue
        }
        
        if let seatInfo = extractSeatInfo(from: text) {
            ticketData.seatNumber = seatInfo
        }
        
        if let price = extractPrice(from: text) {
            ticketData.price = price
        }
        
        guard !ticketData.showName.isEmpty || ticketData.date != nil || !ticketData.place.isEmpty else {
            return .failure(.missingRequiredFields)
        }
        
        return .success(ticketData)
    }
}

// MARK: - Private Parsing Methods
private extension TicketInfoParser {
    func extractShowName(from text: String) -> String? {
        let patterns = [
            // 공연명, 극명, 작품명 등 다양한 패턴
            "(?:공연명|극명|작품명|연극명|뮤지컬명)\\s*[:：]?\\s*([^\\n]+)",
            // 티켓 정보 첫 줄에 오는 공연명
            "^([^\\n]+)(?=\\n|$)",
            // 예매정보 다음에 오는 제목
            "예매정보\\s*\\n\\s*([^\\n]+)"
        ]
        
        return extractFirstMatch(from: text, patterns: patterns)
    }
    
    func extractDateTime(from text: String) -> (date: Date, time: Date)? {
        let patterns = [
            // 관람일시, 공연일시 패턴
            "(?:관람일시|공연일시|일시)\\s*[:：]?\\s*(\\d{4}[.-]\\d{1,2}[.-]\\d{1,2})[^\\d]*(\\d{1,2}[:：]\\d{2})",
            // 날짜와 시간이 분리된 패턴
            "(\\d{4}[.-]\\d{1,2}[.-]\\d{1,2}).*?(\\d{1,2}[:：]\\d{2})",
            // 요일 포함 패턴
            "(\\d{4}[.-]\\d{1,2}[.-]\\d{1,2})\\([가-힣]\\)\\s*(\\d{1,2}[:：]\\d{2})"
        ]
        
        for pattern in patterns {
            if let (date, time) = parseDateTime(from: text, pattern: pattern) {
                return (date, time)
            }
        }
        
        return nil
    }
    
    func extractVenue(from text: String) -> String? {
        let patterns = [
            "(?:장소|공연장|극장|회관|센터|홀)\\s*[:：]?\\s*([^\\n]+)",
            "(?:주소|위치)\\s*[:：]?\\s*([^\\n]+)",
            "([가-힣\\s]+(?:극장|홀|센터|아트홀|대극장|소극장))"
        ]
        
        return extractFirstMatch(from: text, patterns: patterns)
    }
    
    func extractSeatInfo(from text: String) -> String? {
        let patterns = [
            // 좌석 정보 패턴
            "(?:좌석|석)\\s*[:：]?\\s*([A-Za-z가-힣]?\\s*\\d+[열행]?\\s*[A-Za-z가-힣]?\\s*\\d+[번좌석]?)",
            // 구역, 열, 번 패턴
            "([A-Za-z]구역\\s*[A-Za-z]열\\s*\\d+번)",
            // 단순 좌석번호 패턴
            "([A-Za-z]\\d+|\\d+[A-Za-z])"
        ]
        
        return extractFirstMatch(from: text, patterns: patterns)
    }
    
    func extractPrice(from text: String) -> Int? {
        // 금액 숫자만 추출해서 Int로 변환
        let patterns = [
            // 가격, 금액, 요금 형태
            "(?:가격|금액|요금)\\s*[:：]?\\s*([\\d,]+)\\s*원?",
            // 단순 금액 + 원
            "([\\d,]+)원",
            // KRW 표기
            "([\\d,]+)\\s*KRW"
        ]

        if let matched = extractFirstMatch(from: text, patterns: patterns) {
            let cleaned = matched.replacingOccurrences(of: ",", with: "")
            if let value = Int(cleaned) { return value }
        }

        // '무료' 표기 처리 (가격 0원)
        if text.range(of: "무료", options: .caseInsensitive) != nil {
            return 0
        }

        return nil
    }
    
    func extractFirstMatch(from text: String, patterns: [String]) -> String? {
        for pattern in patterns {
            if let range = text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) {
                let match = String(text[range])
                if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                    let nsText = text as NSString
                    let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))
                    if let firstMatch = matches.first, firstMatch.numberOfRanges > 1 {
                        let captureRange = firstMatch.range(at: 1)
                        if captureRange.location != NSNotFound {
                            return nsText.substring(with: captureRange).trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                }
                return match.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return nil
    }
    
    func parseDateTime(from text: String, pattern: String) -> (date: Date, time: Date)? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }
        
        let nsText = text as NSString
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))
        
        guard let match = matches.first, match.numberOfRanges >= 3 else {
            return nil
        }
        
        let dateRange = match.range(at: 1)
        let timeRange = match.range(at: 2)
        
        guard dateRange.location != NSNotFound, timeRange.location != NSNotFound else {
            return nil
        }
        
        let dateString = nsText.substring(with: dateRange)
        let timeString = nsText.substring(with: timeRange)
        
        // 날짜 파싱
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let normalizedDateString = dateString
            .replacingOccurrences(of: "-", with: ".")
            .replacingOccurrences(of: "/", with: ".")
        
        guard let date = dateFormatter.date(from: normalizedDateString) else {
            return nil
        }
        
        // 시간 파싱
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let normalizedTimeString = timeString.replacingOccurrences(of: "：", with: ":")
        
        guard let time = timeFormatter.date(from: normalizedTimeString) else {
            return nil
        }
        
        // 날짜와 시간을 분리해서 반환
        return (date, time)
    }
}
