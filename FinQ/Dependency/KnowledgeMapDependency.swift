//
//  KnowledgeMapDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation
import ComposableArchitecture

private enum KnowledgeMapUseCaseKey: DependencyKey {
    static let liveValue: any KnowledgeMapUseCaseProtocol = KnowledgeMapUseCase(
        repository: KnowledgeMapRepository(
            networkManager: NetworkManager.shared,
            firebaseAnalyticsManager: FirebaseAnalyticsManager.shared
        )
    )
}

extension DependencyValues {
    var knowledgeMapUseCase: any KnowledgeMapUseCaseProtocol {
        get { self[KnowledgeMapUseCaseKey.self] }
        set { self[KnowledgeMapUseCaseKey.self] = newValue }
    }
}
