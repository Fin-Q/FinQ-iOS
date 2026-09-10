//
//  LoginUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

protocol LoginUseCaseProtocol: Sendable {
    func login(email: String, password: String) async throws -> LoginResult
}

struct LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
    
    func login(email: String, password: String) async throws -> LoginResult {
        let input = LoginInput(email: email, password: password)
        return try await repository.login(input: input)
    }
}
