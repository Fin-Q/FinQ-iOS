//
//  KnowledgeMapCategoryDetail.swift
//  FinQ
//
//  Created by 권대윤 on 9/13/26.
//

import Foundation

struct KnowledgeMapCategoryDetail: Equatable, Sendable {
    let categoryID: Int
    let topic: InterestTopic
    let categoryName: String
    let completedContentCount: Int
    let totalContentCount: Int
    let progressRate: Double
    let categoryCompleted: Bool
    let advancedQuizStatus: KnowledgeMapCompletionStatus
    let contents: [KnowledgeMapContent]
    let premiumContents: [KnowledgeMapPremiumContent]
}

struct KnowledgeMapContent: Identifiable, Equatable, Sendable {
    let contentID: Int
    let contentCode: String
    let title: String
    let description: String
    let completionStatus: KnowledgeMapCompletionStatus
    let order: Int

    var id: Int { contentID }
}

struct KnowledgeMapPremiumContent: Identifiable, Equatable, Sendable {
    let contentID: Int
    let title: String

    var id: Int { contentID }
}

enum KnowledgeMapCompletionStatus: Equatable, Sendable {
    case completed
    case incomplete
    case unknown

    init(code: String) {
        switch code {
        case "COMPLETED": self = .completed
        case "INCOMPLETE": self = .incomplete
        default: self = .unknown
        }
    }

    var isCompleted: Bool { self == .completed }
}
