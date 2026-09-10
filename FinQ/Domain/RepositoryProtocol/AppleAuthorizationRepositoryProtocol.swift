//
//  AppleAuthorizationRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

protocol AppleAuthorizationRepositoryProtocol: Sendable {
    func signIn() async throws -> AppleLoginCredential
}
