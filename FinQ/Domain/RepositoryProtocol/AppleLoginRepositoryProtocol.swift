//
//  AppleLoginRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

protocol AppleLoginRepositoryProtocol: Sendable {
    func login(input: AppleLoginInput) async throws -> AppleLoginResult
}
