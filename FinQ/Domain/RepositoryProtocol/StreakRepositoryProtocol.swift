import Foundation

protocol StreakRepositoryProtocol: Sendable {
    func fetchStreakStatus() async throws -> StreakStatus
    func fetchStreakCalendar(month: String?) async throws -> StreakCalendar
}
