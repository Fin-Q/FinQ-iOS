//
//  HomeUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

protocol HomeUseCaseProtocol: Sendable {
    func fetchHome() async throws -> HomeSummary
}

struct HomeUseCase: HomeUseCaseProtocol {
    private let repository: any HomeRepositoryProtocol

    init(repository: any HomeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchHome() async throws -> HomeSummary {
        return try await repository.fetchHome()
    }
}
