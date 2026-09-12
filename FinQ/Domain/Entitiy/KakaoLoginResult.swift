//
//  KakaoLoginResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct KakaoLoginResult: Equatable, Sendable {
    let userID: String
    let nickname: String
    let isNewUser: Bool
    let isOnboardingCompleted: Bool
}
