import ComposableArchitecture

private enum HomeUseCaseKey: DependencyKey {
    static let liveValue: any HomeUseCaseProtocol = HomeUseCase(
        repository: HomeRepository(networkManager: NetworkManager.shared)
    )
}

extension DependencyValues {
    var homeUseCase: any HomeUseCaseProtocol {
        get { self[HomeUseCaseKey.self] }
        set { self[HomeUseCaseKey.self] = newValue }
    }
}
