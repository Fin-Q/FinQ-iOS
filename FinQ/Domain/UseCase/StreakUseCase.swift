import Foundation

protocol StreakUseCaseProtocol: Sendable {
    func fetchStreakStatus() async throws -> StreakStatus
    func fetchStreakCalendar(month: String?) async throws -> StreakCalendar
}

struct StreakUseCase: StreakUseCaseProtocol {
    private let repository: StreakRepositoryProtocol

    init(repository: StreakRepositoryProtocol) {
        self.repository = repository
    }

    func fetchStreakStatus() async throws -> StreakStatus {
        return try await repository.fetchStreakStatus()
    }

    func fetchStreakCalendar(month: String?) async throws -> StreakCalendar {
        return try await repository.fetchStreakCalendar(month: month)
    }
}
