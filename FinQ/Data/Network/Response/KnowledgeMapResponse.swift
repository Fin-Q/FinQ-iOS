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
