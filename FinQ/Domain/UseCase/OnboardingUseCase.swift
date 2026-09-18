//
//  OnboardingUseCase.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

protocol OnboardingUseCaseProtocol: Sendable {
    func getOnboardingStatus() async throws -> OnboardingStatus
    func saveInterests(topics: [InterestTopic]) async throws
    func completeOnboarding() async throws
}

struct OnboardingUseCase: OnboardingUseCaseProtocol {
    private let repository: any OnboardingRepositoryProtocol

    init(repository: any OnboardingRepositoryProtocol) {
        self.repository = repository
    }

    func getOnboardingStatus() async throws -> OnboardingStatus {
        try await repository.getOnboardingStatus()
    }

    func saveInterests(topics: [InterestTopic]) async throws {
        try await repository.saveInterests(input: InterestSelectionInput(topics: topics))
    }

    func completeOnboarding() async throws {
        try await repository.completeOnboarding()
    }
}
