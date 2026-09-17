//
//  MyPageUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

protocol MyPageUseCaseProtocol: Sendable {
    func fetchMyPage() async throws -> MyPageSummary
}

struct MyPageUseCase: MyPageUseCaseProtocol {
    private let repository: any MyPageRepositoryProtocol

    init(repository: any MyPageRepositoryProtocol) {
        self.repository = repository
    }

    func fetchMyPage() async throws -> MyPageSummary {
        return try await repository.fetchMyPage()
    }
}
