//
//  OnboardingDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation
import ComposableArchitecture

private enum OnboardingUseCaseKey: DependencyKey {
    static let liveValue: any OnboardingUseCaseProtocol = OnboardingUseCase(repository: OnboardingRepository(networkManager: NetworkManager.shared))
}

extension DependencyValues {
    var onboardingUseCase: any OnboardingUseCaseProtocol {
        get { self[OnboardingUseCaseKey.self] }
        set { self[OnboardingUseCaseKey.self] = newValue }
    }
}
