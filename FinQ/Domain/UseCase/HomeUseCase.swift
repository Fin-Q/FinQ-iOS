//
//  HomeUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

protocol HomeUseCaseProtocol: Sendable {
    func fetchHome(isGuestMode: Bool) async throws -> HomeSummary
    func logHomeQuestionTapped(contentID: Int, categoryCode: String) async
}

struct HomeUseCase: HomeUseCaseProtocol {
    private let repository: any HomeRepositoryProtocol

    init(repository: any HomeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchHome(isGuestMode: Bool) async throws -> HomeSummary {
        return try await repository.fetchHome(isGuestMode: isGuestMode)
    }

    func logHomeQuestionTapped(contentID: Int, categoryCode: String) async {
        return await repository.logHomeQuestionTapped(contentID: contentID, categoryCode: categoryCode)
    }
}
