//
//  TokenRefreshRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct TokenRefreshRequest: Encodable, Sendable {
    let refreshToken: String
}
