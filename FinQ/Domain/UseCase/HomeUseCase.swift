import Foundation

protocol HomeUseCaseProtocol: Sendable {
    func fetchHome() async throws -> HomeData
}

struct HomeUseCase: HomeUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchHome() async throws -> HomeData {
        return try await repository.fetchHome()
    }
}
