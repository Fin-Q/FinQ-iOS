//
//  AppleLoginInput.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct AppleLoginInput: Equatable, Sendable {
    let credential: AppleLoginCredential
    let nickname: String
    let agreements: [AuthAgreement]
}
