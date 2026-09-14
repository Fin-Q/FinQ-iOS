//
//  StreakMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

extension StreakCalendarResponse {
    func toDomain() -> StreakCalendar {
        return StreakCalendar(month: month, streakDates: Set(streakDates))
    }
}

extension StreakStatusResponse {
    func toDomain() -> StreakStatus {
        return StreakStatus(currentStreak: currentStreak, daysUntilNextBonus: daysUntilNextBonus)
    }
}
