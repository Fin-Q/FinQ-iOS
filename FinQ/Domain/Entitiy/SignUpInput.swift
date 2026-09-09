//
//  SignUpInput.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

struct SignUpInput: Equatable, Sendable {
    let email: String
    let password: String
    let nickname: String
    let agreements: [Agreement]

    struct Agreement: Equatable, Sendable {
        let agreementCode: String
        let version: String
        let agreed: Bool
    }
}
