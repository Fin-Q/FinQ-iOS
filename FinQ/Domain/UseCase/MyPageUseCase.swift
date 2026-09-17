//
//  MyPageUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

protocol MyPageUseCaseProtocol: Sendable {
    func fetchMyPage() async throws -> MyPageSummary
    func updateInterests(topics: [InterestTopic]) async throws
    func updateProfileImage(code: String) async throws
    func updateNickname(_ nickname: String) async throws
    func withdraw() async throws
    func logout() async throws
}

struct MyPageUseCase: MyPageUseCaseProtocol {
    private let repository: any MyPageRepositoryProtocol

    init(repository: any MyPageRepositoryProtocol) {
        self.repository = repository
    }

    func fetchMyPage() async throws -> MyPageSummary {
        return try await repository.fetchMyPage()
    }

    func updateInterests(topics: [InterestTopic]) async throws {
        try await repository.updateInterests(input: InterestSelectionInput(topics: topics))
    }

    func updateProfileImage(code: String) async throws {
        try await repository.updateProfileImage(code: code)
    }

    func updateNickname(_ nickname: String) async throws {
        try await repository.updateNickname(nickname)
    }

    func withdraw() async throws {
        try await repository.withdraw()
    }

    func logout() async throws {
        try await repository.logout()
    }
}
