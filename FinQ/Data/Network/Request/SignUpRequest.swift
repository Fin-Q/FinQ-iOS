//
//  SignUpRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation

struct SignUpRequest: Encodable, Sendable {
    let email: String
    let password: String
    let nickname: String
    let agreements: [SignUpAgreement]
}

struct SignUpAgreement: Encodable, Sendable {
    let agreementCode: String
    let version: String
    let agreed: Bool
}
