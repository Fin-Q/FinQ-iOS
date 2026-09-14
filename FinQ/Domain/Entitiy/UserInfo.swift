import Foundation

struct UserInfo: Equatable, Sendable {
    let userID: String
    let email: String
    let nickname: String
    let profileImageCode: String
    let totalXp: Int
    let currentStreakDays: Int
    let notificationEnabled: Bool
    let interests: [InterestTopic]
}
