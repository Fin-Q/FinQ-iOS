//
//  PasswordResetConfirmRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct PasswordResetConfirmRequest: Encodable, Sendable {
    let passwordResetToken: String
    let newPassword: String
}
