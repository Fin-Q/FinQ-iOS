import Foundation

struct StreakRepository: StreakRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchStreakStatus() async throws -> StreakStatus {
        let response = try await networkManager.perform(api: .fetchStreakStatus, responseType: APIResponse<StreakStatusResponse>.self)
        return response.data.toDomain()
    }

    func fetchStreakCalendar(month: String?) async throws -> StreakCalendar {
        let response = try await networkManager.perform(api: .fetchStreakCalendar(month), responseType: APIResponse<StreakCalendarResponse>.self)
        return response.data.toDomain()
    }
}
