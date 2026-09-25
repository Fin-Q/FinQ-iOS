//
//  HomeRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

struct HomeRepository: HomeRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol
    private let firebaseAnalyticsManager: any FirebaseAnalyticsManagerProtocol

    init(networkManager: any NetworkManagerProtocol, firebaseAnalyticsManager: any FirebaseAnalyticsManagerProtocol) {
        self.networkManager = networkManager
        self.firebaseAnalyticsManager = firebaseAnalyticsManager
    }

    func fetchHome() async throws -> HomeSummary {
        let response = try await networkManager.perform(api: .home, responseType: APIResponse<HomeResponse>.self)
        return response.data.toDomain()
    }

    func logHomeQuestionTapped(contentID: Int, categoryCode: String) async {
        firebaseAnalyticsManager.logHomeQuestionTapped(contentID: contentID, categoryCode: categoryCode)
    }
}
