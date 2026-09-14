//
//  KnowledgeMapResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct KnowledgeMapResponse: Decodable, Sendable {
    let categories: [KnowledgeMapCategoryResponse]
}

struct KnowledgeMapCategoryResponse: Decodable, Sendable {
    let categoryID: Int
    let categoryCode: String
    let categoryName: String
    let completedContentCount: Int
    let totalContentCount: Int
    let progressRate: Double
    let categoryCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryCode
        case categoryName
        case completedContentCount
        case totalContentCount
        case progressRate
        case categoryCompleted
    }
}

struct KnowledgeMapCategoryDetailResponse: Decodable, Sendable {
    let categoryID: Int
    let categoryCode: String
    let categoryName: String
    let completedContentCount: Int
    let totalContentCount: Int
    let progressRate: Double
    let categoryCompleted: Bool
    let advancedQuizStatus: String
    let contents: [KnowledgeMapContentResponse]
    let premiumContents: [KnowledgeMapPremiumContentResponse]

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryCode
        case categoryName
        case completedContentCount
        case totalContentCount
        case progressRate
        case categoryCompleted
        case advancedQuizStatus
        case contents
        case premiumContents
    }
}

struct KnowledgeMapContentResponse: Decodable, Sendable {
    let contentID: Int
    let contentCode: String
    let keyword: [String]
    let title: String
    let description: String
    let completionStatus: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case contentCode
        case keyword
        case title
        case description
        case completionStatus
        case order
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contentID = try container.decode(Int.self, forKey: .contentID)
        contentCode = try container.decode(String.self, forKey: .contentCode)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        completionStatus = try container.decode(String.self, forKey: .completionStatus)
        order = try container.decode(Int.self, forKey: .order)

        if let keywords = try? container.decode([String].self, forKey: .keyword) {
            keyword = keywords
        } else {
            keyword = [try container.decode(String.self, forKey: .keyword)]
        }
    }
}

struct KnowledgeMapPremiumContentResponse: Decodable, Sendable {
    let contentID: Int
    let keyword: [String]
    let title: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case keyword
        case title
        case description
    }
}
