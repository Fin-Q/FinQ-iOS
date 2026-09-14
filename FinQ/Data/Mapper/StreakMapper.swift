import Foundation

extension StreakStatusResponse {
    func toDomain() -> StreakStatus {
        StreakStatus(
            currentStreak: currentStreak,
            daysUntilNextBonus: daysUntilNextBonus
        )
    }
}

extension StreakCalendarResponse {
    func toDomain() -> StreakCalendar {
        StreakCalendar(
            month: month,
            streakDates: streakDates
        )
    }
}
