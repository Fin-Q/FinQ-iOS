//
//  ContentAnswerResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation

struct ContentAnswerResponse: Decodable, Sendable {
    let correct: Bool
    let explanation: String
    let selectedOptionID: String
    let correctOptionID: String
    let nextAction: String
    let contentResult: ContentCompletionResultResponse?

    enum CodingKeys: String, CodingKey {
        case correct
        case explanation
        case selectedOptionID = "selectedOptionId"
        case correctOptionID = "correctOptionId"
        case nextAction
        case contentResult
    }
}

struct ContentCompletionResultResponse: Decodable, Sendable {
    let earnedXP: Int
    let levelUp: Bool
    let newLevel: Int?

    enum CodingKeys: String, CodingKey {
        case earnedXP = "earnedXp"
        case levelUp
        case newLevel
    }
}
