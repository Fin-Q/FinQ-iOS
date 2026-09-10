//
//  KakaoLoginResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct KakaoLoginResponse: Decodable, Sendable {
    let userID: String
    let nickname: String
    let isNewUser: Bool
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int
    let onboardingStatus: OnboardingStatusResponse

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, isNewUser, accessToken, refreshToken, tokenType, accessTokenExpiresIn, onboardingStatus
    }
}
