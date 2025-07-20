import Foundation

struct APIConstants {
    static let isDevelopment = false
    static let baseUrl = isDevelopment ? "http://localhost:8080/api" : "http://43.201.140.227:8080/api"
}
