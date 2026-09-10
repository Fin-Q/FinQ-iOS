//
//  AppleLoginResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

struct AppleLoginResult: Equatable, Sendable {
    let userID: String
    let nickname: String
    let isNewUser: Bool
    let isOnboardingCompleted: Bool
}
