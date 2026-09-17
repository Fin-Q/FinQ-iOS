//
//  MyPageRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

protocol MyPageRepositoryProtocol: Sendable {
    func fetchMyPage() async throws -> MyPageSummary
    func updateInterests(input: InterestSelectionInput) async throws
    func updateProfileImage(code: String) async throws
    func updateNickname(_ nickname: String) async throws
    func logout() async throws
}
