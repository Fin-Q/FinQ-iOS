//
//  AuthDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import ComposableArchitecture

private enum SignUpUseCaseKey: DependencyKey {
    static let liveValue: any SignUpUseCaseProtocol = SignUpUseCase(
        repository: SignUpRepository(
            networkManager: NetworkManager.shared,
            keychainManager: KeychainManager.shared
        )
    )
}

extension DependencyValues {
    var signUpUseCase: any SignUpUseCaseProtocol {
        get { self[SignUpUseCaseKey.self] }
        set { self[SignUpUseCaseKey.self] = newValue }
    }
}

private enum LoginUseCaseKey: DependencyKey {
    static let liveValue: any LoginUseCaseProtocol = LoginUseCase(
        repository: LoginRepository(
            networkManager: NetworkManager.shared,
            keychainManager: KeychainManager.shared
        )
    )
}

extension DependencyValues {
    var loginUseCase: any LoginUseCaseProtocol {
        get { self[LoginUseCaseKey.self] }
        set { self[LoginUseCaseKey.self] = newValue }
    }
}
