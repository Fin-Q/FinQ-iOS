//
//  MyPageRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation

protocol MyPageRepositoryProtocol: Sendable {
    func fetchMyPage() async throws -> MyPageSummary
}
