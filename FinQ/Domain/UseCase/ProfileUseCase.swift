import Foundation

protocol ProfileUseCaseProtocol: Sendable {
    func updateNickname(_ nickname: String) async throws -> String
    func updateProfileImage(_ code: String) async throws -> String
    func updateInterests(_ topics: [InterestTopic]) async throws
}

struct ProfileUseCase: ProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func updateNickname(_ nickname: String) async throws -> String {
        return try await repository.updateNickname(nickname)
    }

    func updateProfileImage(_ code: String) async throws -> String {
        return try await repository.updateProfileImage(code)
    }

    func updateInterests(_ topics: [InterestTopic]) async throws {
        try await repository.updateInterests(topics)
    }
}
