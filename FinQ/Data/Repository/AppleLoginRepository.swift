//
//  AppleLoginRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

struct AppleLoginRepository: AppleLoginRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol
    private let keychainManager: any KeychainManagerProtocol

    init(networkManager: any NetworkManagerProtocol, keychainManager: any KeychainManagerProtocol) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }

    func login(input: AppleLoginInput) async throws -> AppleLoginResult {
        try Task.checkCancellation()
        let response = try await networkManager.perform(api: .appleLogin(input.toRequest()), responseType: APIResponse<AppleLoginResponse>.self)
        try Task.checkCancellation()
        guard !response.data.accessToken.isEmpty, !response.data.refreshToken.isEmpty else { throw TokenStorageError.invalidTokens }

        try saveTokens(accessToken: response.data.accessToken, refreshToken: response.data.refreshToken)
        return response.data.toDomain()
    }

    private func saveTokens(accessToken: String, refreshToken: String) throws {
        let previousAccessToken = keychainManager.getItem(forKey: .accessToken)
        guard keychainManager.saveItem(item: accessToken, forKey: .accessToken) else { throw TokenStorageError.saveFailed }
        guard keychainManager.saveItem(item: refreshToken, forKey: .refreshToken) else {
            // 리프레시 토큰 저장 실패 시 이전 액세스 토큰으로 되돌립니다.
            if let previousAccessToken { _ = keychainManager.saveItem(item: previousAccessToken, forKey: .accessToken) }
            else { _ = keychainManager.deleteItem(forKey: .accessToken) }
            throw TokenStorageError.saveFailed
        }
    }

    private enum TokenStorageError: LocalizedError {
        case invalidTokens, saveFailed

        var errorDescription: String? {
            switch self {
            case .invalidTokens: "로그인 정보를 받지 못했어요. 다시 시도해 주세요."
            case .saveFailed: "로그인 정보를 안전하게 저장하지 못했어요. 다시 시도해 주세요."
            }
        }
    }
}
