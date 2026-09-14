//
//  KnowledgeMapMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

extension KnowledgeMapCategoryResponse {
    func toDomain() throws -> KnowledgeMapCategory {
        guard let topic = InterestTopic(rawValue: categoryCode) else { throw KnowledgeMapMappingError.invalidCategoryCode(categoryCode) }
        return KnowledgeMapCategory(categoryID: categoryID, topic: topic, categoryName: categoryName, completedContentCount: completedContentCount, totalContentCount: totalContentCount, progressRate: progressRate, categoryCompleted: categoryCompleted)
    }
}

extension KnowledgeMapCategoryDetailResponse {
    func toDomain() throws -> KnowledgeMapCategoryDetail {
        guard let topic = InterestTopic(rawValue: categoryCode) else { throw KnowledgeMapMappingError.invalidCategoryCode(categoryCode) }
        return KnowledgeMapCategoryDetail(categoryID: categoryID, topic: topic, categoryName: categoryName, completedContentCount: completedContentCount, totalContentCount: totalContentCount, progressRate: progressRate, categoryCompleted: categoryCompleted, advancedQuizStatus: KnowledgeMapCompletionStatus(code: advancedQuizStatus), contents: contents.map { $0.toDomain() }, premiumContents: premiumContents.map { $0.toDomain() })
    }
}

private extension KnowledgeMapContentResponse {
    func toDomain() -> KnowledgeMapContent {
        return KnowledgeMapContent(contentID: contentID, contentCode: contentCode, keyword: keyword, title: title, description: description, completionStatus: KnowledgeMapCompletionStatus(code: completionStatus), order: order)
    }
}

private extension KnowledgeMapPremiumContentResponse {
    func toDomain() -> KnowledgeMapPremiumContent {
        return KnowledgeMapPremiumContent(contentID: contentID, keyword: keyword, title: title)
    }
}

private enum KnowledgeMapMappingError: LocalizedError {
    case invalidCategoryCode(String)

    var errorDescription: String? {
        switch self {
        case let .invalidCategoryCode(code): "지원하지 않는 지식맵 카테고리입니다. (\(code))"
        }
    }
}
