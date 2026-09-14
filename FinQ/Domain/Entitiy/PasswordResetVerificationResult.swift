//
//  PasswordResetVerificationResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct PasswordResetVerificationResult: Equatable, Sendable {
    let verificationID: String
    let expiresIn: Int
    let resendAvailableIn: Int
}
