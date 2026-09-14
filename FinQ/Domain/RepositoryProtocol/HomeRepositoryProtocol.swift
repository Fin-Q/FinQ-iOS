import Foundation

protocol HomeRepositoryProtocol: Sendable {
    func fetchHome() async throws -> HomeData
}
