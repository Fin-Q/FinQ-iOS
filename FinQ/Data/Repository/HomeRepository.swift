//
//  HomeRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct HomeRepository: HomeRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchHome() async throws -> HomeSummary {
        let response = try await networkManager.perform(api: .home, responseType: APIResponse<HomeResponse>.self)
        return response.data.toDomain()
    }
}
