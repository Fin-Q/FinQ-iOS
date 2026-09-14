import Foundation

struct HomeRepository: HomeRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchHome() async throws -> HomeData {
        let response = try await networkManager.perform(api: .fetchHome, responseType: APIResponse<HomeResponse>.self)
        return response.data.toDomain()
    }
}
