//
//  HomeDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation
import ComposableArchitecture

private enum HomeUseCaseKey: DependencyKey {
    static let liveValue: any HomeUseCaseProtocol = HomeUseCase(repository: HomeRepository(networkManager: NetworkManager.shared))
}

private enum StreakUseCaseKey: DependencyKey {
    static let liveValue: any StreakUseCaseProtocol = StreakUseCase(repository: StreakRepository(networkManager: NetworkManager.shared))
}

extension DependencyValues {
    var homeUseCase: any HomeUseCaseProtocol {
        get { self[HomeUseCaseKey.self] }
        set { self[HomeUseCaseKey.self] = newValue }
    }

    var streakUseCase: any StreakUseCaseProtocol {
        get { self[StreakUseCaseKey.self] }
        set { self[StreakUseCaseKey.self] = newValue }
    }
}
