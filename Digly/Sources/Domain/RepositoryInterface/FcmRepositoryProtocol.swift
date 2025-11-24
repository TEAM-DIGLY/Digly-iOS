import Foundation

protocol FcmRepositoryProtocol {
    func registerToken(_ token: String) async throws
}
