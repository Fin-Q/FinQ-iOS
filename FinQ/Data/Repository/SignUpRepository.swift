//
//  SignUpRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation

struct SignUpRepository: SignUpRepositoryProtocol {
    private let networkManager: any NetworkManagerProtocol
    private let keychainManager: any KeychainManagerProtocol

    init(networkManager: any NetworkManagerProtocol, keychainManager: any KeychainManagerProtocol) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }

    func signUp(input: SignUpInput) async throws -> SignUpResult {
        let request = input.toRequest()
        
        let response = try await networkManager.perform(api: .signUp(request), responseType: APIResponse<SignUpResponseData>.self)
        
        _ = keychainManager.saveItem(item: response.data.accessToken, forKey: .accessToken)
        _ = keychainManager.saveItem(item: response.data.refreshToken, forKey: .refreshToken)
        
        return response.data.toDomain()
    }
}
