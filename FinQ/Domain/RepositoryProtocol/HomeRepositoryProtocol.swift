//
//  HomeRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation

protocol HomeRepositoryProtocol: Sendable {
    func fetchHome() async throws -> HomeSummary
    func logHomeQuestionTapped(contentID: Int, categoryCode: String) async
}
