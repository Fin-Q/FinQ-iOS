import Foundation

struct StreakStatus: Equatable, Sendable {
    let currentStreak: Int
    let daysUntilNextBonus: Int
}
