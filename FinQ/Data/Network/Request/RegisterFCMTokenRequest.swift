//
//  RegisterFCMTokenRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation

struct RegisterFCMTokenRequest: Encodable, Sendable {
    let deviceID: String
    let fcmToken: String
    let platform: String = "IOS"
}
