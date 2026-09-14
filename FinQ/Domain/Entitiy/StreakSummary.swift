//
//  StreakSummary.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct StreakCalendar: Equatable, Sendable {
    let month: String
    let streakDates: Set<String>
}

struct StreakStatus: Equatable, Sendable {
    let currentStreak: Int
    let daysUntilNextBonus: Int

    var bonusProgress: Double {
        let currentStreak = max(0, currentStreak)
        let remainingDays = max(0, daysUntilNextBonus)
        let totalDays = currentStreak + remainingDays
        return totalDays > 0 ? Double(currentStreak) / Double(totalDays) : 0
    }
}
