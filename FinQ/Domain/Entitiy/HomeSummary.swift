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
