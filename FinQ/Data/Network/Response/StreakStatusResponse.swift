import Foundation

struct StreakStatusResponse: Decodable, Sendable {
    let currentStreak: Int
    let daysUntilNextBonus: Int
}
