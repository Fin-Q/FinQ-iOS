//
//  VerificationCodeConfirmInput.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct VerificationCodeConfirmInput: Equatable, Sendable {
    let id: String
    let code: String
}
