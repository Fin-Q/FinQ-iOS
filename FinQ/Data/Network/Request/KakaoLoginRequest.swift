//
//  KakaoLoginRequest.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct KakaoLoginRequest: Encodable, Sendable {
    let kakaoAccessToken: String
    let nickname: String
    let agreements: [SignUpAgreement]
}
