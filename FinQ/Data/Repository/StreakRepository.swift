//
//  StreakRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct StreakRepository: StreakRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchCalendar(month: String?) async throws -> StreakCalendar {
        let response = try await networkManager.perform(api: .streakCalendar(month: month), responseType: APIResponse<StreakCalendarResponse>.self)
        return response.data.toDomain()
    }

    func fetchStatus() async throws -> StreakStatus {
        let response = try await networkManager.perform(api: .streakStatus, responseType: APIResponse<StreakStatusResponse>.self)
        return response.data.toDomain()
    }
}
