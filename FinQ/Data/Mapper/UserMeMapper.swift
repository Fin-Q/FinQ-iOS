import Foundation

extension UserMeResponse {
    func toDomain() -> UserInfo {
        return UserInfo(
            userID: self.userId,
            email: self.email,
            nickname: self.nickname,
            profileImageCode: self.profileImageCode,
            totalXp: self.totalXp,
            currentStreakDays: self.currentStreakDays,
            notificationEnabled: self.notificationEnabled,
            interests: self.interests.compactMap { InterestTopic(rawValue: $0.categoryCode) }
        )
    }
}
