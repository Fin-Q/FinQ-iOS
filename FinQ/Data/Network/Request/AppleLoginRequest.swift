//
//  AppleLoginRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct AppleLoginRequest: Encodable, Sendable {
    let identityToken: String
    let authorizationCode: String
    let nonce: String
    let nickname: String
    let agreements: [SignUpAgreement]
}
