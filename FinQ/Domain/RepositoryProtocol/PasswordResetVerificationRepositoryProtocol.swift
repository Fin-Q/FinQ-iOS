//
//  PasswordResetVerificationRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

protocol PasswordResetVerificationRepositoryProtocol: Sendable {
    func sendVerification(input: PasswordResetVerificationInput) async throws -> PasswordResetVerificationResult
}
