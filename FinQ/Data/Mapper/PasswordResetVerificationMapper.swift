//
//  PasswordResetVerificationMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

extension PasswordResetVerificationInput {
    func toRequest() -> PasswordResetVerificationRequest {
        PasswordResetVerificationRequest(loginID: loginID)
    }
}

extension PasswordResetVerificationResponse {
    func toDomain() -> PasswordResetVerificationResult {
        PasswordResetVerificationResult(verificationID: verificationID, expiresIn: expiresIn, resendAvailableIn: resendAvailableIn)
    }
}
