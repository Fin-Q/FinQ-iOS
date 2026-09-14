//
//  KnowledgeMapCategory.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct KnowledgeMapCategory: Identifiable, Equatable, Sendable {
    let categoryID: Int
    let topic: InterestTopic
    let categoryName: String
    let completedContentCount: Int
    let totalContentCount: Int
    let progressRate: Double
    let categoryCompleted: Bool

    var id: Int { categoryID }
}
