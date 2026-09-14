import Foundation

struct ProfileRepository: ProfileRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func updateNickname(_ nickname: String) async throws -> String {
        let response = try await networkManager.perform(api: .patchNickname(nickname), responseType: APIResponse<NicknameUpdateResponse>.self)
        return response.data.toDomain()
    }

    func updateProfileImage(_ code: String) async throws -> String {
        let response = try await networkManager.perform(api: .patchProfileImage(code), responseType: APIResponse<ProfileImageUpdateResponse>.self)
        return response.data.toDomain()
    }

    func updateInterests(_ topics: [InterestTopic]) async throws {
        let request = InterestSelectionRequest(interestTopicIds: topics.map(\.id))
        _ = try await networkManager.perform(api: .saveInterests(request), responseType: APIResponse<OnboardingResponse>.self)
    }
}
