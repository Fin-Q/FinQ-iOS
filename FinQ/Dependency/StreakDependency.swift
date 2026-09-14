import ComposableArchitecture

private enum StreakUseCaseKey: DependencyKey {
    static let liveValue: any StreakUseCaseProtocol = StreakUseCase(
        repository: StreakRepository(networkManager: NetworkManager.shared)
    )
}

extension DependencyValues {
    var streakUseCase: any StreakUseCaseProtocol {
        get { self[StreakUseCaseKey.self] }
        set { self[StreakUseCaseKey.self] = newValue }
    }
}
