//
//  KakaoAuthManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/2/26.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

struct KakaoOAuthResult: Sendable {
    let accessToken: String
}

enum KakaoOAuthError: LocalizedError, Sendable {
    case requestAlreadyInProgress
    case missingOAuthToken

    var errorDescription: String? {
        switch self {
        case .requestAlreadyInProgress: "카카오 로그인이 이미 진행 중이에요. 잠시 기다려 주세요."
        case .missingOAuthToken: "카카오 인증 정보를 받지 못했어요. 다시 시도해 주세요."
        }
    }
}

@MainActor
protocol KakaoOAuthManagerProtocol {
    func login() async throws -> KakaoOAuthResult
}

@MainActor
final class KakaoOAuthManager: KakaoOAuthManagerProtocol {
    
    static let shared = KakaoOAuthManager()
    private init() { }

    private var continuation: CheckedContinuation<KakaoOAuthResult, any Error>?
    private var requestID: UUID?
    
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
        guard continuation == nil else { throw KakaoOAuthError.requestAlreadyInProgress }

        let requestID = UUID()

        return try await withTaskCancellationHandler {
            try Task.checkCancellation()

            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                self.requestID = requestID

                request { [weak self] oauthToken, error in
                    guard let self, self.requestID == requestID else { return }

                    if let sdkError = error as? SdkError, case .ClientFailed(reason: .Cancelled, errorMessage: _) = sdkError {
                        self.finish(with: .failure(CancellationError()))
                        return
                    }

                    if let sdkError = error as? SdkError, case .AuthFailed(reason: .AccessDenied, errorInfo: _) = sdkError {
                        self.finish(with: .failure(CancellationError()))
                        return
                    }

                    if let error {
                        AppLogger.shared.log("카카오 로그인 에러: \(error)", level: .error)
                        self.finish(with: .failure(error))
                        return
                    }

                    guard let oauthToken, !oauthToken.accessToken.isEmpty else {
                        AppLogger.shared.log("카카오 토큰 손실", level: .error)
                        self.finish(with: .failure(KakaoOAuthError.missingOAuthToken))
                        return
                    }

                    self.finish(with: .success(KakaoOAuthResult(accessToken: oauthToken.accessToken)))
                }
            }
        } onCancel: {
            Task { @MainActor [weak self] in
                guard let self, self.requestID == requestID else { return }
                self.finish(with: .failure(CancellationError()))
            }
        }
    }

    private func finish(with result: Result<KakaoOAuthResult, any Error>) {
        guard let continuation else { return }

        self.continuation = nil
        requestID = nil
        continuation.resume(with: result)
    }
}
