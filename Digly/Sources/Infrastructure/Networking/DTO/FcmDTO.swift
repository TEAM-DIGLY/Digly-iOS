import Foundation

// MARK: - POST /api/v1/fcm
struct PostFcmRequest: Codable {
    let token: String
}

struct PostFcmResponse: Codable {
    let status: Int
    let message: String
    let data: EmptyData
}
