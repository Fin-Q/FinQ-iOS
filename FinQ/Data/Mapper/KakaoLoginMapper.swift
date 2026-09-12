//
//  KakaoLoginMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

extension KakaoOAuthResult {
    func toDomain() -> KakaoLoginCredential {
        return KakaoLoginCredential(accessToken: accessToken)
    }
}

extension KakaoLoginInput {
    func toRequest() -> KakaoLoginRequest {
        return KakaoLoginRequest(kakaoAccessToken: credential.accessToken, nickname: nickname, agreements: agreements.map { SignUpAgreement(agreementCode: $0.agreementCode, version: $0.version, agreed: $0.agreed) })
    }
}

extension KakaoLoginResponse {
    func toDomain() -> KakaoLoginResult {
        return KakaoLoginResult(userID: userID, nickname: nickname, isNewUser: isNewUser, isOnboardingCompleted: onboardingStatus == .completed)
    }
}
