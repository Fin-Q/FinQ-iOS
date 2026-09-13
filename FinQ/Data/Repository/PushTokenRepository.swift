//
//  PushTokenRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct PushTokenRepository: PushTokenRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol
    private let keychainManager: any KeychainManagerProtocol

    init(networkManager: any NetworkManagerProtocol, keychainManager: any KeychainManagerProtocol) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }

    @MainActor
    func registerCurrentToken() async throws {
        guard let fcmToken = keychainManager.getItem(forKey: .fcmToken), !fcmToken.isEmpty else { return }

        let deviceID = AppInfo.getDeviceID()
        guard !deviceID.isEmpty else { return }

        let request = RegisterFCMTokenRequest(deviceID: deviceID, fcmToken: fcmToken)
        _ = try await networkManager.perform(api: .registerFCMToken(request), responseType: APIResponse<EmptyResponse>.self)
    }
}
