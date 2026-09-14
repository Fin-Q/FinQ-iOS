//
//  PasswordResetVerificationRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct PasswordResetVerificationRequest: Encodable, Sendable {
    let loginID: String

    enum CodingKeys: String, CodingKey {
        case loginID = "loginId"
    }
}
