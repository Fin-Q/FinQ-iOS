//
//  StreakResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct StreakCalendarResponse: Decodable, Sendable {
    let month: String
    let streakDates: [String]
}

struct StreakStatusResponse: Decodable, Sendable {
    let currentStreak: Int
    let daysUntilNextBonus: Int
}
