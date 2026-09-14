import Foundation

struct StreakCalendarResponse: Decodable, Sendable {
    let month: String
    let streakDates: [String]
}
