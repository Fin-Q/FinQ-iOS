//
//  LoginRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

protocol LoginRepositoryProtocol: Sendable {
    func login(input: LoginInput) async throws -> LoginResult
}
