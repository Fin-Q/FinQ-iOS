//
//  KnowledgeMapRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/12/26.
//

import Foundation

protocol KnowledgeMapRepositoryProtocol: Sendable {
    func fetchCategories() async throws -> [KnowledgeMapCategory]
}
