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

private enum KnowledgeMapMappingError: LocalizedError {
    case invalidCategoryCode(String)

    var errorDescription: String? {
        switch self {
        case let .invalidCategoryCode(code): "지원하지 않는 지식맵 카테고리입니다. (\(code))"
        }
    }
}
