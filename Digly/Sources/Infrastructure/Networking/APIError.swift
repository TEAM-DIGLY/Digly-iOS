import Foundation

enum APIError: Error, Equatable {
    case networkError
    case unauthorized
    case invalidURL
    case timeout
    case notFound
    case decodingError
    case unknown
    case responseFailure
    
    case serverError(String)
    case validationError(String)
    case duplicateData(String)
    
    init(error: Error) {
        switch error {
        case let urlError as URLError:
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                self = .networkError
            case .badURL, .unsupportedURL:
                self = .invalidURL
            case .timedOut:
                self = .timeout
            default:
                self = .unknown
            }
            
        case let apiError as APIError:
            self = apiError
            
        case is DecodingError:
            self = .decodingError
            
        default:
            self = .unknown
        }
    }
    
    static func from(statusCode: Int, message: String? = nil) -> APIError {
        switch statusCode {
        case 400:
            return .validationError(message ?? "잘못된 요청입니다")
        case 401:
            return .unauthorized
        case 403:
            return .serverError("접근이 거부되었습니다")
        case 404:
            return .notFound
        case 409:
            return .duplicateData(message ?? "이미 존재하는 정보입니다")
        case 422:
            return .validationError(message ?? "입력 정보가 올바르지 않습니다")
        case 500...599:
            return .serverError("서버 오류가 발생했습니다")
        default:
            return .unknown
        }
    }
    
    var isAutoHandled: Bool {
        switch self {
        case .networkError, .unauthorized, .invalidURL, .timeout, .notFound, .decodingError, .unknown:
            true
        case .serverError, .validationError, .duplicateData, .responseFailure:
            false
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return "보안을 위해 다시 로그인해 주세요."
        case .networkError:
            return "네트워크 연결에 문제가 있어요. 와이파이나 데이터 연결을 확인해 주세요."
        case .timeout:
            return "요청 시간이 초과되었습니다. 다시 시도해 주세요."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다"
        case .invalidURL:
            return "잘못된 URL입니다. 잠시 후 다시 시도해 주세요."
        case .decodingError:
            return "서버 응답을 처리하는 중 오류가 발생했습니다."
        case .serverError(let message):
            return message
        case .validationError(let message):
            return message
        case .duplicateData(let message):
            return message
        case .unknown, .responseFailure:
            return "알 수 없는 문제가 발생했어요. 앱을 다시 실행해 보시겠어요?"
        }
    }
}