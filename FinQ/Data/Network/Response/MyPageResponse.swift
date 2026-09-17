//
//  MyPageResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

struct MyPageResponse: Decodable, Sendable {
    let userID: String
    let email: String
    let nickname: String
    let profileImageCode: String
    let profileImageURL: String
    let totalXP: Int
    let currentStreakDays: Int
    let notificationEnabled: Bool
    let interests: [MyPageInterestResponse]

    enum CodingKeys: String, CodingKey {
        case email, nickname, profileImageCode, currentStreakDays, notificationEnabled, interests
        case userID = "userId"
        case profileImageURL = "profileImageUrl"
        case totalXP = "totalXp"
    }
}

struct MyPageInterestResponse: Decodable, Sendable {
    let categoryID: Int
    let categoryCode: String
    let categoryName: String

    enum CodingKeys: String, CodingKey {
        case categoryCode, categoryName
        case categoryID = "categoryId"
    }
}
