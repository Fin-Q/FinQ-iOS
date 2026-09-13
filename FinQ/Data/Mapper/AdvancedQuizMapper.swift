//
//  AdvancedQuizMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

extension AdvancedQuizResponse {
    func toDomain() -> AdvancedQuiz {
        return AdvancedQuiz(categoryID: categoryID, categoryName: categoryName, rewardXP: rewardXP, introTitle: introTitle, introDescription: introDescription, completionTitle: completionTitle, completionDescription: completionDescription, questions: questions.map { $0.toDomain() })
    }
}

private extension AdvancedQuizQuestionResponse {
    func toDomain() -> AdvancedQuizQuestion {
        return AdvancedQuizQuestion(questionID: questionID, order: order, questionType: questionType, questionBody: questionBody, options: options.map { $0.toDomain() })
    }
}

private extension AdvancedQuizOptionResponse {
    func toDomain() -> AdvancedQuizOption {
        return AdvancedQuizOption(optionID: optionID, optionText: optionText)
    }
}
