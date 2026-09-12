//
//  PasswordResetMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

extension PasswordResetInput {
    func toRequest() -> PasswordResetConfirmRequest {
        return PasswordResetConfirmRequest(passwordResetToken: passwordResetToken, newPassword: newPassword)
    }
}
