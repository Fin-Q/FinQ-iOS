//
//  SignUpResult.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

struct SignUpResult: Equatable, Sendable {
    let userID: String
    let accessToken: String
    let refreshToken: String
}
