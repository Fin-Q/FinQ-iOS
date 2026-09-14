//
//  LoginMapper.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

extension LoginInput {
    func toRequest() -> LoginRequest {
        return LoginRequest(email: self.email, password: self.password)
    }
}

extension LoginResponse {
    func toDomain() -> LoginResult {
        return LoginResult(
            userID: self.userId,
            nickname: self.nickname,
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            isOnboardingCompleted: self.onboardingStatus == .completed
        )
    }
}
