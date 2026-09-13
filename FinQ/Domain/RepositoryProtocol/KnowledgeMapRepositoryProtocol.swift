//
//  KnowledgeMapRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

protocol KnowledgeMapRepositoryProtocol: Sendable {
    func fetchCategories() async throws -> [KnowledgeMapCategory]
    func fetchCategoryDetail(topic: InterestTopic) async throws -> KnowledgeMapCategoryDetail
    func fetchAdvancedQuiz(categoryID: Int) async throws -> AdvancedQuiz
    func logPremiumContentTapped(contentID: Int, categoryCode: String) async
}
