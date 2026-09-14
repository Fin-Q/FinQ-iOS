//
//  PasswordResetVerificationResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct PasswordResetVerificationResponse: Decodable, Sendable {
    let verificationID: String
    let expiresIn: Int
    let resendAvailableIn: Int

    enum CodingKeys: String, CodingKey {
        case verificationID = "verificationId"
        case expiresIn
        case resendAvailableIn
    }
}
