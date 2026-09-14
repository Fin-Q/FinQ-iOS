//
//  HomeResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct HomeResponse: Decodable, Sendable {
    let nickname: String
    let level: Int
    let characterStage: Int
    let totalXP: Int
    let currentStreak: Int
    let questions: [HomeQuestionResponse]

    enum CodingKeys: String, CodingKey {
        case nickname, level, characterStage, currentStreak, questions
        case totalXP = "totalXp"
    }
}

struct HomeQuestionResponse: Decodable, Sendable {
    let contentID: Int
    let categoryCode: String
    let categoryName: String
    let title: String
    let completionStatus: String

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case categoryCode, categoryName, title, completionStatus
    }
}
