//
//  MyPageRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

struct MyPageRepository: MyPageRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchMyPage() async throws -> MyPageSummary {
        let response = try await networkManager.perform(api: .myPage, responseType: APIResponse<MyPageResponse>.self)
        return response.data.toDomain()
    }
}
