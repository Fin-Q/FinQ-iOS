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
    func fetchContent(contentID: Int) async throws -> LearningContent
    func submitContentAnswer(contentID: Int, questionID: Int, selectedOptionID: String) async throws -> ContentAnswerResult
    func fetchAdvancedQuiz(categoryID: Int) async throws -> AdvancedQuiz
    func submitAdvancedQuizAnswer(categoryID: Int, questionID: Int, selectedOptionID: String) async throws -> AdvancedQuizAnswerResult
    func logPremiumContentTapped(contentID: Int, categoryCode: String) async
    func logFirstLearningStart(contentID: Int, categoryCode: String) async
    func logFirstLearningComplete(contentID: Int, categoryCode: String) async
    func logHomeTapTargetLearningStart(contentID: Int, categoryCode: String) async
    func logDifferentLearningStartAfterComplete(contentID: Int, categoryCode: String) async
    func logSameLearningStartAfterComplete(contentID: Int, categoryCode: String) async
    func logLearningComplete(contentID: Int, categoryCode: String) async
}
