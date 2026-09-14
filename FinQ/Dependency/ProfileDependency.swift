import ComposableArchitecture

private enum ProfileUseCaseKey: DependencyKey {
    static let liveValue: any ProfileUseCaseProtocol = ProfileUseCase(
        repository: ProfileRepository(networkManager: NetworkManager.shared)
    )
}

extension DependencyValues {
    var profileUseCase: any ProfileUseCaseProtocol {
        get { self[ProfileUseCaseKey.self] }
        set { self[ProfileUseCaseKey.self] = newValue }
    }
}
