//
//  SignUpResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

struct SignUpResponseData: Decodable, Sendable {
    let userID: String
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int
    let onboardingStatus: OnboardingStatusResponse

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case accessToken
        case refreshToken
        case tokenType
        case accessTokenExpiresIn
        case onboardingStatus
    }
}

enum OnboardingStatusResponse: String, Decodable, Sendable {
    case interestSelection = "INTEREST_SELECTION"
    case characterGuide = "CHARACTER_GUIDE"
    case completed = "COMPLETED"
}
