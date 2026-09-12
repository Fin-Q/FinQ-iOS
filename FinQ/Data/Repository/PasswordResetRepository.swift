//
//  PasswordResetRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

struct PasswordResetRepository: PasswordResetRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol

    init(networkManager: any NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func resetPassword(input: PasswordResetInput) async throws {
        _ = try await networkManager.perform(api: .passwordReset(input.toRequest()), responseType: APIResponse<EmptyResponse>.self)
    }
}
