//
//  PasswordResetRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

protocol PasswordResetRepositoryProtocol: Sendable {
    func resetPassword(input: PasswordResetInput) async throws
}
