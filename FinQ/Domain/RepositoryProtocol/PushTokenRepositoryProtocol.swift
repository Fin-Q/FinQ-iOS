//
//  PushTokenRepositoryProtocol.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

protocol PushTokenRepositoryProtocol: Sendable {
    @MainActor
    func registerCurrentToken() async throws
}
