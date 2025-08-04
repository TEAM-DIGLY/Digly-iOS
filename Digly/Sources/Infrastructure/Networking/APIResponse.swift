import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}

struct ContentResponse<T: Codable>: Codable {
    let content: [T]
}

struct EmptyResult: Codable {}
