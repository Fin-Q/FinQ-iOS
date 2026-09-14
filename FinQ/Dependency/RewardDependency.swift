import ComposableArchitecture

private enum RewardUseCaseKey: DependencyKey {
    static let liveValue: any RewardUseCaseProtocol = RewardUseCase(
        repository: RewardRepository(networkManager: NetworkManager.shared)
    )
}

extension DependencyValues {
    var rewardUseCase: any RewardUseCaseProtocol {
        get { self[RewardUseCaseKey.self] }
        set { self[RewardUseCaseKey.self] = newValue }
    }
}
