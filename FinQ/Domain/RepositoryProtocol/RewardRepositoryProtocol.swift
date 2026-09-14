import Foundation

protocol RewardRepositoryProtocol: Sendable {
    func fetchRewardStatus() async throws -> RewardStatus
}
