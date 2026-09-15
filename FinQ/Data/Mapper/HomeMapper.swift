//
//  HomeMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

extension HomeResponse {
    func toDomain() -> HomeSummary {
        return HomeSummary(nickname: nickname, level: level, characterStage: characterStage, characterImageURL: characterImageURL, totalXP: totalXP, currentStreak: currentStreak, questions: questions.map { $0.toDomain() })
    }
}

private extension HomeQuestionResponse {
    func toDomain() -> HomeQuestion {
        return HomeQuestion(contentID: contentID, categoryCode: categoryCode, categoryName: categoryName, title: title, completionStatus: KnowledgeMapCompletionStatus(code: completionStatus))
    }
}
