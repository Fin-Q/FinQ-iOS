//
//  AppleLoginMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

extension AppleOAuthResult {
    func toDomain() -> AppleLoginCredential {
        return AppleLoginCredential(identityToken: identityToken, authorizationCode: authorizationCode, rawNonce: rawNonce, issuedAt: issuedAt)
    }
}

extension AppleLoginInput {
    func toRequest() -> AppleLoginRequest {
        return AppleLoginRequest(identityToken: credential.identityToken, authorizationCode: credential.authorizationCode, nonce: credential.rawNonce, nickname: nickname, agreements: agreements.map { SignUpAgreement(agreementCode: $0.agreementCode, version: $0.version, agreed: $0.agreed) })
    }
}

extension AppleLoginResponse {
    func toDomain() -> AppleLoginResult {
        return AppleLoginResult(userID: userID, nickname: nickname, isNewUser: isNewUser, isOnboardingCompleted: onboardingStatus == .completed)
    }
}
