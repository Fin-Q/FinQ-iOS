//
//  LoginResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

struct LoginResult: Equatable, Sendable {
    let userID: String
    let nickname: String
    let accessToken: String
    let refreshToken: String
    let isOnboardingCompleted: Bool
}
