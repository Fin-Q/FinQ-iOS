import Foundation

extension RewardStatusResponse {
    func toDomain() -> RewardStatus {
        RewardStatus(
            totalXp: totalXp,
            level: level,
            characterStage: characterStage
        )
    }
}
