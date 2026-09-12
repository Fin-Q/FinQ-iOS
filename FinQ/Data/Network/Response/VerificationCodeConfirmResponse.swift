//
//  VerificationCodeConfirmResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct VerificationCodeConfirmResponse: Decodable, Sendable {
    let passwordResetToken: String
    let expiresIn: Int
}
