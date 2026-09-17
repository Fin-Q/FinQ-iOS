//
//  ContentAnswerResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation

struct ContentAnswerResult: Equatable, Sendable {
    let correct: Bool
    let explanation: String
    let selectedOptionID: String
    let correctOptionID: String
    let nextAction: ContentNextAction
    let contentResult: ContentCompletionResult?
}

enum ContentNextAction: String, Equatable, Sendable {
    case nextBody = "NEXT_BODY"
    case nextSummary = "NEXT_SUMMARY"
    case nextQuestion = "NEXT_QUESTION"
    case contentCompleted = "CONTENT_COMPLETED"
    case retry = "RETRY"
}

struct ContentCompletionResult: Equatable, Sendable {
    let earnedXP: Int
    let levelUp: Bool
    let newLevel: Int?
}
