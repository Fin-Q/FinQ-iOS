//
//  AdvancedQuizResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct AdvancedQuizResponse: Decodable, Sendable {
    let categoryID: Int
    let categoryName: String
    let rewardXP: Int
    let introTitle: String
    let introDescription: String
    let completionTitle: String
    let completionDescription: String
    let questions: [AdvancedQuizQuestionResponse]

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName
        case rewardXP = "rewardXp"
        case introTitle
        case introDescription
        case completionTitle
        case completionDescription
        case questions
    }
}

struct AdvancedQuizQuestionResponse: Decodable, Sendable {
    let questionID: Int
    let order: Int
    let questionType: String
    let questionBody: String
    let options: [AdvancedQuizOptionResponse]

    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case order
        case questionType
        case questionBody
        case options
    }
}

struct AdvancedQuizOptionResponse: Decodable, Sendable {
    let optionID: String
    let optionText: String

    enum CodingKeys: String, CodingKey {
        case optionID = "optionId"
        case optionText
    }
}
