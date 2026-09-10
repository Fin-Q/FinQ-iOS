//
//  SignUpUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation

protocol SignUpUseCaseProtocol: Sendable {
    func signUp(email: String, password: String, nickname: String) async throws -> SignUpResult
}

struct SignUpUseCase: SignUpUseCaseProtocol {
    private let repository: any SignUpRepositoryProtocol

    init(repository: any SignUpRepositoryProtocol) {
        self.repository = repository
    }

    func signUp(email: String, password: String, nickname: String) async throws -> SignUpResult {
        let input = SignUpInput(email: email, password: password, nickname: nickname, agreements: AuthAgreement.required)

        return try await repository.signUp(input: input)
    }
}
