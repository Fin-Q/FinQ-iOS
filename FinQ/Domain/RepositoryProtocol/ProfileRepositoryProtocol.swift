import Foundation

protocol ProfileRepositoryProtocol: Sendable {
    func updateNickname(_ nickname: String) async throws -> String
    func updateProfileImage(_ code: String) async throws -> String
    func updateInterests(_ topics: [InterestTopic]) async throws
}
