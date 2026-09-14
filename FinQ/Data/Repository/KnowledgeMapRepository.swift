//
//  KnowledgeMapRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct KnowledgeMapRepository: KnowledgeMapRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol
    private let firebaseAnalyticsManager: any FirebaseAnalyticsManagerProtocol

    init(
        networkManager: any NetworkManagerProtocol,
        firebaseAnalyticsManager: any FirebaseAnalyticsManagerProtocol
    ) {
        self.networkManager = networkManager
        self.firebaseAnalyticsManager = firebaseAnalyticsManager
    }

    func fetchCategories() async throws -> [KnowledgeMapCategory] {
        let response = try await networkManager.perform(api: .knowledgeMap, responseType: APIResponse<KnowledgeMapResponse>.self)
        return try response.data.categories.map { try $0.toDomain() }
    }

    func fetchCategoryDetail(topic: InterestTopic) async throws -> KnowledgeMapCategoryDetail {
        let response = try await networkManager.perform(api: .categoryDetail(topic.rawValue), responseType: APIResponse<KnowledgeMapCategoryDetailResponse>.self)
        return try response.data.toDomain()
    }

    func fetchAdvancedQuiz(categoryID: Int) async throws -> AdvancedQuiz {
        let response = try await networkManager.perform(api: .advancedQuiz(categoryID), responseType: APIResponse<AdvancedQuizResponse>.self)
        return response.data.toDomain()
    }

    func submitAdvancedQuizAnswer(categoryID: Int, questionID: Int, selectedOptionID: String) async throws -> AdvancedQuizAnswerResult {
        let request = AdvancedQuizAnswerRequest(selectedOptionID: selectedOptionID)
        let response = try await networkManager.perform(api: .submitAdvancedQuizAnswer(categoryID: categoryID, questionID: questionID, request: request), responseType: APIResponse<AdvancedQuizAnswerResponse>.self)
        return response.data.toDomain()
    }
    
    func logPremiumContentTapped(contentID: Int, categoryCode: String) async {
        firebaseAnalyticsManager.logPremiumContentTapped(contentID: contentID, categoryCode: categoryCode)
    }
}
