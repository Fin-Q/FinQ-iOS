//
//  LoginRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

struct LoginRequest: Encodable, Sendable {
    let email: String
    let password: String
}
