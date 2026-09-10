//
//  KakaoLoginInput.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation

struct KakaoLoginInput: Equatable, Sendable {
    let credential: KakaoLoginCredential
    let nickname: String
    let agreements: [AuthAgreement]
}
