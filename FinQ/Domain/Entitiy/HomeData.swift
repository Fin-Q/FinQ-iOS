import Foundation

struct HomeData: Equatable, Sendable {
    let nickname: String
    let level: Int
    let characterStage: Int
    let totalXp: Int
    let currentStreak: Int
    let questions: [QuestionCard]
}

struct QuestionCard: Equatable, Identifiable, Sendable {
    let contentId: String
    let categoryCode: String
    let categoryName: String
    let title: String
    let isCompleted: Bool

    var id: String { contentId }
}
