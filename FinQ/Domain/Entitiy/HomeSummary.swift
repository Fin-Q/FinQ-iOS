//
//  HomeSummary.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct HomeSummary: Equatable, Sendable {
    let nickname: String
    let level: Int
    let characterStage: Int
    let characterImageURL: String
    let totalXP: Int
    let currentStreak: Int
    let questions: [HomeQuestion]

    var levelProgress: Double {
        let bounds: (lower: Int, upper: Int)
        switch level {
        case 1: bounds = (0, 80)
        case 2: bounds = (80, 180)
        case 3: bounds = (180, 300)
        case 4...: return 1
        default: return 0
        }
        return min(1, max(0, Double(totalXP - bounds.lower) / Double(bounds.upper - bounds.lower)))
    }
}

struct HomeQuestion: Identifiable, Equatable, Sendable {
    let contentID: Int
    let categoryCode: String
    let categoryName: String
    let title: String
    let completionStatus: KnowledgeMapCompletionStatus

    var id: Int { contentID }
}

extension HomeSummary {
    static let guest = HomeSummary(
        nickname: "로그인하고 캐릭터를 키워보세요",
        level: 1,
        characterStage: 1,
        characterImageURL: "",
        totalXP: 0,
        currentStreak: 0,
        questions: [
            HomeQuestion(
                contentID: -1,
                categoryCode: "SAL",
                categoryName: "월급관리·저축",
                title: "월급은 들어왔는데 왜 매달 남는 돈이 없을까요?",
                completionStatus: .incomplete
            ),
            HomeQuestion(
                contentID: -2,
                categoryCode: "SAL",
                categoryName: "월급관리·저축",
                title: "돈을 아끼려면 커피값부터 줄여야 할까요?",
                completionStatus: .incomplete
            ),
            HomeQuestion(
                contentID: -3,
                categoryCode: "SAL",
                categoryName: "월급관리·저축",
                title: "모아둔 돈, 전부 투자해도 괜찮을까요?",
                completionStatus: .incomplete
            ),
        ]
    )
}
