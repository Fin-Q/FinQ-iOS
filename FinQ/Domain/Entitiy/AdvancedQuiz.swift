//
//  AdvancedQuiz.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct AdvancedQuiz: Equatable, Sendable {
    let categoryID: Int
    let categoryName: String
    let rewardXP: Int
    let introTitle: String
    let introDescription: String
    let completionTitle: String
    let completionDescription: String
    let questions: [AdvancedQuizQuestion]
}

struct AdvancedQuizQuestion: Identifiable, Equatable, Sendable {
    let questionID: Int
    let order: Int
    let questionType: String
    let questionBody: String
    let options: [AdvancedQuizOption]

    var id: Int { questionID }
}

struct AdvancedQuizOption: Identifiable, Equatable, Sendable {
    let optionID: String
    let optionText: String

    var id: String { optionID }
}
