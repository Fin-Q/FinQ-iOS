//
//  OnboardingRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct OnboardingRepository: OnboardingRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func saveInterests(input: InterestSelectionInput) async throws {
        _ = try await networkManager.perform(api: .saveInterests(input.toRequest()), responseType: APIResponse<OnboardingResponse>.self)
    }

    func completeOnboarding() async throws {
        _ = try await networkManager.perform(api: .completeOnboarding, responseType: APIResponse<OnboardingResponse>.self)
    }
}
