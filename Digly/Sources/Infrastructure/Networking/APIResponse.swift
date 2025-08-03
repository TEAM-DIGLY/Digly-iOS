import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}

struct PageableResponse<T: Codable>: Codable {
    struct Pagination: Codable {
        let page: Int
        let size: Int
        let total: Int
        let hasNext: Bool
    }
    let content: [T]
    let pagination: Pagination
}

struct ContentResponse<T: Codable>: Codable {
    let content: [T]
}

struct EmptyResult: Codable {}
