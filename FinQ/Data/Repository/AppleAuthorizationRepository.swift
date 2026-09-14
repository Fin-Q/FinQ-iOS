//
//  AppleAuthorizationRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct AppleAuthorizationRepository: AppleAuthorizationRepositoryProtocol {
    func signIn() async throws -> AppleLoginCredential {
        try await AppleOAuthManager.shared.signIn().toDomain()
    }
}
