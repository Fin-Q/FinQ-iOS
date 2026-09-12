//
//  KnowledgeMapUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

protocol KnowledgeMapUseCaseProtocol: Sendable {
    func fetchCategories() async throws -> [KnowledgeMapCategory]
}

struct KnowledgeMapUseCase: KnowledgeMapUseCaseProtocol {
    private let repository: any KnowledgeMapRepositoryProtocol

    init(repository: any KnowledgeMapRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCategories() async throws -> [KnowledgeMapCategory] {
        return try await repository.fetchCategories()
    }
}
