import ComposableArchitecture

private enum UserInfoUseCaseKey: DependencyKey {
    static let liveValue: any UserInfoUseCaseProtocol = UserInfoUseCase(
        repository: UserRepository(networkManager: NetworkManager.shared)
    )
}

extension DependencyValues {
    var userInfoUseCase: any UserInfoUseCaseProtocol {
        get { self[UserInfoUseCaseKey.self] }
        set { self[UserInfoUseCaseKey.self] = newValue }
    }
}
