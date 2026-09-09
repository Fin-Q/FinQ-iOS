//
//  SignUpMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

extension SignUpInput {
    func toRequest() -> SignUpRequest {
        SignUpRequest(
            email: email,
            password: password,
            nickname: nickname,
            agreements: agreements.map {
                SignUpAgreement(
                    agreementCode: $0.agreementCode,
                    version: $0.version,
                    agreed: $0.agreed
                )
            }
        )
    }
}

extension SignUpResponseData {
    func toDomain() -> SignUpResult {
        SignUpResult(
            userID: userID,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
