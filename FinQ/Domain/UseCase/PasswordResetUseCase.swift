//
//  PasswordResetUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

protocol PasswordResetUseCaseProtocol: Sendable {
    func resetPassword(passwordResetToken: String, newPassword: String) async throws
}

struct PasswordResetUseCase: PasswordResetUseCaseProtocol {
    private let repository: any PasswordResetRepositoryProtocol

    init(repository: any PasswordResetRepositoryProtocol) {
        self.repository = repository
    }

    func resetPassword(passwordResetToken: String, newPassword: String) async throws {
        try await repository.resetPassword(input: PasswordResetInput(passwordResetToken: passwordResetToken, newPassword: newPassword))
    }
}
