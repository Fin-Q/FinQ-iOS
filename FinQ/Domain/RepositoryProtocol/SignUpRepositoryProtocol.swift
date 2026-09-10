//
//  SignUpRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

protocol SignUpRepositoryProtocol: Sendable {
    func signUp(input: SignUpInput) async throws -> SignUpResult
}
