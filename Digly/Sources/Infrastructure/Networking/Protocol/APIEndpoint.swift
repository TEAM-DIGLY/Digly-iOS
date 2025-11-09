import Foundation

protocol APIEndpoint: Equatable {
    var path: String { get }
    var method: HTTPMethod { get }
    var tokenType: TokenType { get }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

enum TokenType {
    case none
    case accessToken
    case refreshToken
    case custom(key: String, value: String)
}