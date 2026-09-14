//
//  AppleLoginCredential.swift
//  FinQ
//
//  Created by 권대윤 on 9/9/26.
//

import Foundation

struct AppleLoginCredential: Equatable, Sendable {
    let identityToken: String
    let authorizationCode: String
    /// 서버에는 32자리 원본을 전달하고, Apple 요청에는 이 원본의 SHA-256 해시를 사용
    let rawNonce: String
    let issuedAt: Date

    // 5분 유효한 일회용 코드를 전송하기 전에 30초의 여유를 둡니다.
    func needsReauthorization(at date: Date) -> Bool { date.timeIntervalSince(issuedAt) >= 270 }
}
