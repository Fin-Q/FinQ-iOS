import Foundation

struct UserMeResponse: Decodable, Sendable {
    let userId: String
    let email: String
    let nickname: String
    let profileImageCode: String
    let totalXp: Int
    let currentStreakDays: Int
    let notificationEnabled: Bool
    let onboardingStatus: OnboardingStatusResponse
    let interests: [InterestResponse]
}
