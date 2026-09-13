//
//  PushTokenDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

private enum PushTokenUseCaseKey: DependencyKey {
    static let liveValue: any PushTokenUseCaseProtocol = PushTokenUseCase(repository: PushTokenRepository(networkManager: NetworkManager.shared, keychainManager: KeychainManager.shared))
}

extension DependencyValues {
    var pushTokenUseCase: any PushTokenUseCaseProtocol {
        get { self[PushTokenUseCaseKey.self] }
        set { self[PushTokenUseCaseKey.self] = newValue }
    }
}
