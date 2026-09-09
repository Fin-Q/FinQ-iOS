//
//  LoginResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

struct LoginResponse: Decodable, Sendable {
    let userId: String
    let nickname: String
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int
    let onboardingStatus: OnboardingStatusResponse
}
