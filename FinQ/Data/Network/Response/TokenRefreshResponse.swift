//
//  TokenRefreshResponse.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct TokenRefreshResponse: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int64
    let refreshTokenExpiresIn: Int64
}
