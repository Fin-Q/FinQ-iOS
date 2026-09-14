import Foundation

protocol UserInfoUseCaseProtocol: Sendable {
    func fetchUserInfo() async throws -> UserInfo
}

struct UserInfoUseCase: UserInfoUseCaseProtocol {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func fetchUserInfo() async throws -> UserInfo {
        return try await repository.fetchUserInfo()
    }
}
