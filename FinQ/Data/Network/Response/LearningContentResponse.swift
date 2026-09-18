//
//  LearningContentResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation

struct LearningContentResponse: Decodable, Sendable {
    let contentID: Int
    let title: String
    let blocks: [LearningContentBlockResponse]

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case title
        case blocks
    }
}

struct LearningContentBlockResponse: Decodable, Sendable {
    let blockType: String
    let title: String?
    let content: [LearningBodyElementResponse]?
    let questionID: Int?
    let questionType: String?
    let questionBody: String?
    let options: [LearningQuestionOptionResponse]?

    enum CodingKeys: String, CodingKey {
        case blockType
        case title
        case content
        case questionID = "questionId"
        case questionType
        case questionBody
        case options
    }
}

struct LearningBodyElementResponse: Decodable, Sendable {
    let type: String
    let text: String?
    let items: [LearningBoxItemResponse]?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case items
        case imageURL = "imageUrl"
    }
}

struct LearningBoxItemResponse: Decodable, Sendable {
    let title: String?
    let text: String
}

struct LearningQuestionOptionResponse: Decodable, Sendable {
    let optionID: String
    let optionText: String

    enum CodingKeys: String, CodingKey {
        case optionID = "optionId"
        case optionText
    }
}
