import Foundation

struct HomeResponse: Decodable, Sendable {
    let nickname: String
    let level: Int
    let characterStage: Int
    let totalXp: Int
    let currentStreak: Int
    let questions: [QuestionResponse]
}

struct QuestionResponse: Decodable, Sendable {
    let contentId: String
    let categoryCode: String
    let categoryName: String
    let title: String
    let completionStatus: String
}
