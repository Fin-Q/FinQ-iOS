//
//  KakaoAuthorizationRepository.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct KakaoAuthorizationRepository: KakaoAuthorizationRepositoryProtocol {
    func signIn() async throws -> KakaoLoginCredential {
        try await KakaoOAuthManager.shared.login().toDomain()
    }
}
