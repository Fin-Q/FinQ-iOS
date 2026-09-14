//
//  StreakUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

protocol StreakUseCaseProtocol: Sendable {
    func fetchCalendar(month: String?) async throws -> StreakCalendar
    func fetchStatus() async throws -> StreakStatus
}

struct StreakUseCase: StreakUseCaseProtocol {
    private let repository: any StreakRepositoryProtocol

    init(repository: any StreakRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCalendar(month: String?) async throws -> StreakCalendar {
        return try await repository.fetchCalendar(month: month)
    }

    func fetchStatus() async throws -> StreakStatus {
        return try await repository.fetchStatus()
    }
}
