//
//  LoginRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

struct LoginRepository: LoginRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, keychainManager: KeychainManagerProtocol) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
    
    func login(input: LoginInput) async throws -> LoginResult {
        let request = input.toRequest()
        
        let response = try await networkManager.perform(api: .login(request), responseType: APIResponse<LoginResponse>.self)
        
        _ = keychainManager.saveItem(item: response.data.accessToken, forKey: .accessToken)
        _ = keychainManager.saveItem(item: response.data.refreshToken, forKey: .refreshToken)
        
        return response.data.toDomain()
    }

    func hasActiveSession() -> Bool {
        guard let accessToken = keychainManager.getItem(forKey: .accessToken), !accessToken.isEmpty, let refreshToken = keychainManager.getItem(forKey: .refreshToken), !refreshToken.isEmpty else { return false }
        return true
    }

    func clearSession() {
        _ = keychainManager.deleteItem(forKey: .accessToken)
        _ = keychainManager.deleteItem(forKey: .refreshToken)
    }
}
