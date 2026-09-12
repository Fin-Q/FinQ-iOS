//
//  VerificationCodeConfirmResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct VerificationCodeConfirmResult: Equatable, Sendable {
    let passwordResetToken: String
    let expireSeconds: Int
}
