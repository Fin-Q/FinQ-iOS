//
//  AuthAgreement.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct AuthAgreement: Equatable, Sendable {
    let agreementCode: String
    let version: String
    let agreed: Bool

    static let required: [Self] = [
        .init(agreementCode: "TERMS_OF_SERVICE", version: "1.0", agreed: true),
        .init(agreementCode: "PRIVACY_POLICY", version: "1.0", agreed: true)
    ]
}
