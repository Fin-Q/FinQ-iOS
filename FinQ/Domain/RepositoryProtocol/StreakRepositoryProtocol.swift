//
//  StreakRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

protocol StreakRepositoryProtocol: Sendable {
    func fetchProfileImageURL() async throws -> String
    func fetchCalendar(month: String?) async throws -> StreakCalendar
    func fetchStatus() async throws -> StreakStatus
}
