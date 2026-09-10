//
//  PasswordResetVerificationUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

protocol PasswordResetVerificationUseCaseProtocol: Sendable {
    func sendVerification(loginID: String) async throws -> PasswordResetVerificationResult
}

struct PasswordResetVerificationUseCase: PasswordResetVerificationUseCaseProtocol {
    private let repository: any PasswordResetVerificationRepositoryProtocol

    init(repository: any PasswordResetVerificationRepositoryProtocol) {
        self.repository = repository
    }

    func sendVerification(loginID: String) async throws -> PasswordResetVerificationResult {
        try await repository.sendVerification(input: PasswordResetVerificationInput(loginID: loginID))
    }
}
