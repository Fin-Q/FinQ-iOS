import Foundation

struct RewardRepository: RewardRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchRewardStatus() async throws -> RewardStatus {
        let response = try await networkManager.perform(api: .fetchRewardStatus, responseType: APIResponse<RewardStatusResponse>.self)
        return response.data.toDomain()
    }
}
