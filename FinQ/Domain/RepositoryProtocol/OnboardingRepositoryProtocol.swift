//
//  OnboardingRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

protocol OnboardingRepositoryProtocol: Sendable {
    func isOnboardingCompleted() async throws -> Bool
    func saveInterests(input: InterestSelectionInput) async throws
    func completeOnboarding() async throws
}
