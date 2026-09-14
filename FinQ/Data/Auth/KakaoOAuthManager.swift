//
//  KakaoAuthManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/2/26.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth

struct KakaoOAuthResult: Sendable {
    let idToken: String
    let accessToken: String
}

enum KakaoOAuthError: Error, Sendable {
    case missingOAuthToken
}

@MainActor
protocol KakaoOAuthManagerProtocol {
    func login() async throws -> KakaoOAuthResult
}

@MainActor
final class KakaoOAuthManager: KakaoOAuthManagerProtocol {
    
    static let shared = KakaoOAuthManager()
    private init() { }
    
    func login() async throws -> KakaoOAuthResult {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
           // 카카오톡 로그인
            return try await performLogin { completion in
                UserApi.shared.loginWithKakaoTalk(completion: completion)
            }
         }
        
        else {
            // 카카오계정 로그인
            return try await performLogin { completion in
                UserApi.shared.loginWithKakaoAccount(completion: completion)
            }
        }
    }
    
    private func performLogin(_ request: (@escaping (OAuthToken?, Error?) -> Void) -> Void) async throws -> KakaoOAuthResult {
        return try await withCheckedThrowingContinuation { continuation in
            request { oauthToken, error in
                if let error {
                    AppLogger.shared.log("카카오 로그인 에러: \(error)", level: .error)
                    continuation.resume(with: .failure(error))
                    return
                }
                
                guard let oauthToken,
                      let idToken = oauthToken.idToken else {
                    AppLogger.shared.log("카카오 토큰 손실", level: .error)
                    continuation.resume(with: .failure(KakaoOAuthError.missingOAuthToken))
                    return
                }
                
                let result = KakaoOAuthResult(idToken: idToken, accessToken: oauthToken.accessToken)
                continuation.resume(with: .success(result))
                return
            }
        }
    }
}
