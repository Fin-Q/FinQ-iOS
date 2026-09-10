//
//  AuthDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import ComposableArchitecture

//MARK: - SignUpUseCaseKey

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

//MARK: - LoginUseCaseKey

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

//MARK: - PasswordResetVerificationUseCaseKey

private enum PasswordResetVerificationUseCaseKey: DependencyKey {
    static let liveValue: any PasswordResetVerificationUseCaseProtocol = PasswordResetVerificationUseCase(repository: PasswordResetVerificationRepository(networkManager: NetworkManager.shared))
}

extension DependencyValues {
    var passwordResetVerificationUseCase: any PasswordResetVerificationUseCaseProtocol {
        get { self[PasswordResetVerificationUseCaseKey.self] }
        set { self[PasswordResetVerificationUseCaseKey.self] = newValue }
    }
}

//MARK: - AppleOAuthUseCaseKey

private enum AppleOAuthUseCaseKey: DependencyKey {
    static let liveValue: any AppleOAuthUseCaseProtocol = AppleOAuthUseCase(authorizationRepository: AppleAuthorizationRepository(), loginRepository: AppleLoginRepository(networkManager: NetworkManager.shared, keychainManager: KeychainManager.shared))
}

extension DependencyValues {
    var appleOAuthUseCase: any AppleOAuthUseCaseProtocol {
        get { self[AppleOAuthUseCaseKey.self] }
        set { self[AppleOAuthUseCaseKey.self] = newValue }
    }
}

//MARK: - KakaoOAuthUseCaseKey

private enum KakaoOAuthUseCaseKey: DependencyKey {
    static let liveValue: any KakaoOAuthUseCaseProtocol = KakaoOAuthUseCase(authorizationRepository: KakaoAuthorizationRepository(), loginRepository: KakaoLoginRepository(networkManager: NetworkManager.shared, keychainManager: KeychainManager.shared))
}

extension DependencyValues {
    var kakaoOAuthUseCase: any KakaoOAuthUseCaseProtocol {
        get { self[KakaoOAuthUseCaseKey.self] }
        set { self[KakaoOAuthUseCaseKey.self] = newValue }
    }
}
