//
//  AdvancedQuizAnswerResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct AdvancedQuizAnswerResponse: Decodable, Sendable {
    let correct: Bool
    let explanation: String
    let selectedOptionID: String
    let correctOptionID: String
    let isLastQuestion: Bool
    let categoryResult: AdvancedQuizCategoryResultResponse?

    enum CodingKeys: String, CodingKey {
        case correct
        case explanation
        case selectedOptionID = "selectedOptionId"
        case correctOptionID = "correctOptionId"
        case isLastQuestion
        case categoryResult
    }
}

struct AdvancedQuizCategoryResultResponse: Decodable, Sendable {
    let earnedXP: Int
    let levelUp: Bool
    let newLevel: Int?

    enum CodingKeys: String, CodingKey {
        case earnedXP = "earnedXp"
        case levelUp
        case newLevel
    }
}
