//
//  PushTokenUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

protocol PushTokenUseCaseProtocol: Sendable {
    @MainActor
    func registerCurrentToken() async throws
}

struct PushTokenUseCase: PushTokenUseCaseProtocol {
    private let repository: any PushTokenRepositoryProtocol

    init(repository: any PushTokenRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func registerCurrentToken() async throws {
        try await repository.registerCurrentToken()
    }
}
