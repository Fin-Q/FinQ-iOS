import Foundation

struct UserRepository: UserRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchUserInfo() async throws -> UserInfo {
        let response = try await networkManager.perform(api: .fetchUserMe, responseType: APIResponse<UserMeResponse>.self)
        return response.data.toDomain()
    }
}
