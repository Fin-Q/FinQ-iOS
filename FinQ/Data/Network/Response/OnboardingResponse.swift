//
//  OnboardingResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct OnboardingResponse: Decodable, Sendable {
    let onboardingStatus: OnboardingStatusResponse
    let interests: [InterestResponse]
}

struct InterestResponse: Decodable, Sendable {
    let categoryID: Int
    let categoryCode: String
    let categoryName: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryCode
        case categoryName
    }
}
