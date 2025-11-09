import Foundation

// MARK: - Pagination
struct Pagination: Codable {
    let pageNum: Int
    let pageSize: Int
    let totalElements: Int
    let totalPages: Int
}

// MARK: - Empty Data
struct EmptyData: Codable {}
