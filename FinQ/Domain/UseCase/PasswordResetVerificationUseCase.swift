//
//  PasswordResetVerificationUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

protocol PasswordResetVerificationUseCaseProtocol: Sendable {
    func sendVerification(loginID: String) async throws -> PasswordResetVerificationResult
    func confirmVerificationCode(id: String, code: String) async throws -> VerificationCodeConfirmResult
}

struct PasswordResetVerificationUseCase: PasswordResetVerificationUseCaseProtocol {
    private let repository: any PasswordResetVerificationRepositoryProtocol

    init(repository: any PasswordResetVerificationRepositoryProtocol) {
        self.repository = repository
    }

    func sendVerification(loginID: String) async throws -> PasswordResetVerificationResult {
        try await repository.sendVerification(input: PasswordResetVerificationInput(loginID: loginID))
    }

    func confirmVerificationCode(id: String, code: String) async throws -> VerificationCodeConfirmResult {
        try await repository.confirmVerificationCode(input: .init(id: id, code: code))
    }
}
