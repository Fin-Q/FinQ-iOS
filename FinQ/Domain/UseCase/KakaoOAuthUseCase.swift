//
//  KakaoOAuthUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

protocol KakaoOAuthUseCaseProtocol: Sendable {
    func signIn() async throws -> KakaoLoginCredential
    func login(credential: KakaoLoginCredential, nickname: String) async throws -> KakaoLoginResult
}

struct KakaoOAuthUseCase: KakaoOAuthUseCaseProtocol {
    private let authorizationRepository: any KakaoAuthorizationRepositoryProtocol
    private let loginRepository: any KakaoLoginRepositoryProtocol

    init(authorizationRepository: any KakaoAuthorizationRepositoryProtocol, loginRepository: any KakaoLoginRepositoryProtocol) {
        self.authorizationRepository = authorizationRepository
        self.loginRepository = loginRepository
    }

    func signIn() async throws -> KakaoLoginCredential {
        try await authorizationRepository.signIn()
    }

    func login(credential: KakaoLoginCredential, nickname: String) async throws -> KakaoLoginResult {
        try await loginRepository.login(input: KakaoLoginInput(credential: credential, nickname: nickname, agreements: AuthAgreement.required))
    }
}
