//
//  PasswordResetVerificationMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

extension PasswordResetVerificationInput {
    func toRequest() -> PasswordResetVerificationRequest {
        return PasswordResetVerificationRequest(loginID: loginID)
    }
}

extension PasswordResetVerificationResponse {
    func toDomain() -> PasswordResetVerificationResult {
        return PasswordResetVerificationResult(verificationID: verificationID, expiresIn: expiresIn, resendAvailableIn: resendAvailableIn)
    }
}

extension VerificationCodeConfirmInput {
    func toRequest() -> VerificationCodeConfirmRequest {
        return VerificationCodeConfirmRequest(verificationId: id, verificationCode: code)
    }
}

extension VerificationCodeConfirmResponse {
    func toDomain() -> VerificationCodeConfirmResult {
        return VerificationCodeConfirmResult(passwordResetToken: passwordResetToken, expireSeconds: expiresIn)
    }
}
