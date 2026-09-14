//
//  AdvancedQuizAnswerResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct AdvancedQuizAnswerResult: Equatable, Sendable {
    let correct: Bool
    let explanation: String
    let selectedOptionID: String
    let correctOptionID: String
    let isLastQuestion: Bool
    let categoryResult: AdvancedQuizCategoryResult?
}

struct AdvancedQuizCategoryResult: Equatable, Sendable {
    let earnedXP: Int
    let levelUp: Bool
    let newLevel: Int?
}
