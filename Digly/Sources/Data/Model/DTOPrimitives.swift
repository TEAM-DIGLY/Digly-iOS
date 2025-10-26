import Foundation

struct Pagination: Codable {
    let pageNum: Int
    let pageSize: Int
    let totalElements: Int
    let totalPages: Int
}

struct EmptyResult: Codable {}

protocol BaseResponse: Codable {
    var statusCode: Int? { get }
    var message: String? { get }
}

extension BaseResponse {
    var isSuccess: Bool {
        guard let code = statusCode else { return true }
        return (200...299).contains(code)
    }

    var isCreated: Bool { statusCode == 201 }
    var isOK: Bool { statusCode == 200 }

    func ensureSuccess() throws {
        guard isSuccess else {
            let code = statusCode ?? 500
            let msg = message ?? "Unknown error"
            throw APIError.serverError(msg)
        }
    }
}
