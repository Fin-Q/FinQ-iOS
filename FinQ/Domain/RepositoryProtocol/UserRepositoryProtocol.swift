import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchUserInfo() async throws -> UserInfo
}
