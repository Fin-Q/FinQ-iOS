//
//  MyPageDependency.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

private enum MyPageUseCaseKey: DependencyKey {
    static let liveValue: any MyPageUseCaseProtocol = MyPageUseCase(repository: MyPageRepository(networkManager: NetworkManager.shared))
}

extension DependencyValues {
    var myPageUseCase: any MyPageUseCaseProtocol {
        get { self[MyPageUseCaseKey.self] }
        set { self[MyPageUseCaseKey.self] = newValue }
    }
}
