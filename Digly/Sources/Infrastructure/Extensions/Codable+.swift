import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        // Match OpenAPI date-time (ISO8601 with timezone)
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}

extension JSONDecoder {
    static var diglyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        // Date decoding strategy for ISO8601 format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            } else if let date = dateFormatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)"
                )
            }
        }
        
        return decoder
    }
}
