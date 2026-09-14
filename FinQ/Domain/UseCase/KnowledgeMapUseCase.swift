//
//  KnowledgeMapUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

protocol KnowledgeMapUseCaseProtocol: Sendable {
    func fetchCategories() async throws -> [KnowledgeMapCategory]
    func fetchCategoryDetail(topic: InterestTopic) async throws -> KnowledgeMapCategoryDetail
    func logPremiumContentTapped(contentID: Int, categoryCode: String) async
}

struct KnowledgeMapUseCase: KnowledgeMapUseCaseProtocol {
    private let repository: any KnowledgeMapRepositoryProtocol

    init(repository: any KnowledgeMapRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCategories() async throws -> [KnowledgeMapCategory] {
        return try await repository.fetchCategories()
    }

    func fetchCategoryDetail(topic: InterestTopic) async throws -> KnowledgeMapCategoryDetail {
        return try await repository.fetchCategoryDetail(topic: topic)
    }
    
    func logPremiumContentTapped(contentID: Int, categoryCode: String) async {
        return await repository.logPremiumContentTapped(contentID: contentID, categoryCode: categoryCode)
    }
}
