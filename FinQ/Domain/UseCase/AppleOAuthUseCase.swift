//
//  AppleOAuthUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

protocol AppleOAuthUseCaseProtocol: Sendable {
    func signIn() async throws -> AppleLoginCredential
    func login(credential: AppleLoginCredential, nickname: String) async throws -> AppleLoginResult
}

struct AppleOAuthUseCase: AppleOAuthUseCaseProtocol {
    private let authorizationRepository: any AppleAuthorizationRepositoryProtocol
    private let loginRepository: any AppleLoginRepositoryProtocol

    init(authorizationRepository: any AppleAuthorizationRepositoryProtocol, loginRepository: any AppleLoginRepositoryProtocol) {
        self.authorizationRepository = authorizationRepository
        self.loginRepository = loginRepository
    }

    func signIn() async throws -> AppleLoginCredential {
        try await authorizationRepository.signIn()
    }

    func login(credential: AppleLoginCredential, nickname: String) async throws -> AppleLoginResult {
        try await loginRepository.login(input: AppleLoginInput(credential: credential, nickname: nickname, agreements: AuthAgreement.required))
    }
}
