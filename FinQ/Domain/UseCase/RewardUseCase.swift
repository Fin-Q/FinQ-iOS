import Foundation

protocol RewardUseCaseProtocol: Sendable {
    func fetchRewardStatus() async throws -> RewardStatus
}

struct RewardUseCase: RewardUseCaseProtocol {
    private let repository: RewardRepositoryProtocol

    init(repository: RewardRepositoryProtocol) {
        self.repository = repository
    }

    func fetchRewardStatus() async throws -> RewardStatus {
        return try await repository.fetchRewardStatus()
    }
}
