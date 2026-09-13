//
//  KnowledgeMapRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct KnowledgeMapRepository: KnowledgeMapRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchCategories() async throws -> [KnowledgeMapCategory] {
        let response = try await networkManager.perform(api: .knowledgeMap, responseType: APIResponse<KnowledgeMapResponse>.self)
        return try response.data.categories.map { try $0.toDomain() }
    }

    func fetchCategoryDetail(topic: InterestTopic) async throws -> KnowledgeMapCategoryDetail {
        let response = try await networkManager.perform(api: .categoryDetail(topic.rawValue), responseType: APIResponse<KnowledgeMapCategoryDetailResponse>.self)
        return try response.data.toDomain()
    }
}
