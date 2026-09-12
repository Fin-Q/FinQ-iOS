//
//  VerificationCodeConfirmRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct VerificationCodeConfirmRequest: Encodable, Sendable {
    let verificationId: String
    let verificationCode: String
}
