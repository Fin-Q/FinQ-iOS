//
//  KakaoAuthorizationRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

protocol KakaoAuthorizationRepositoryProtocol: Sendable {
    func signIn() async throws -> KakaoLoginCredential
}
