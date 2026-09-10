//
//  AuthInterceptor.swift
//  FinQ
//
//  Created by 권대윤 on 9/10/26.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor, Sendable {
    private let coordinator: TokenRefreshCoordinator

    init(keychainManager: any KeychainManagerProtocol = KeychainManager.shared) {
        self.coordinator = TokenRefreshCoordinator(keychainManager: keychainManager)
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
        Task {
            do {
                var request = urlRequest
                let accessToken = try await coordinator.accessToken()
                request.setValue(accessToken.map { "Bearer \($0)" }, forHTTPHeaderField: "Authorization")
                completion(.success(request))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping @Sendable (RetryResult) -> Void) {
        guard !request.isCancelled, request.response?.statusCode == 401, request.retryCount == 0 else {
            completion(.doNotRetry)
            return
        }

        let authorization = request.request?.value(forHTTPHeaderField: "Authorization")
        Task {
            do {
                try await coordinator.refresh(failedAuthorization: authorization)
                completion(request.isCancelled ? .doNotRetry : .retry)
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

private actor TokenRefreshCoordinator {
    private let keychainManager: any KeychainManagerProtocol
    // 갱신 요청에는 인터셉터를 연결하지 않아 갱신 API의 401 재귀 호출 방지
    private let session = Session()
    private var refreshTask: Task<Void, any Error>?

    init(keychainManager: any KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }

    func accessToken() async throws -> String? {
        // 갱신 중 시작한 요청도 새 토큰이 저장된 뒤 전송
        if let refreshTask { try await refreshTask.value }
        guard let token = keychainManager.getItem(forKey: .accessToken), !token.isEmpty else { return nil }
        return token
    }

    func refresh(failedAuthorization: String?) async throws {
        if let refreshTask {
            try await refreshTask.value
            return
        }

        // 이전 토큰으로 전송된 요청의 401이 늦게 도착하면 추가 갱신 없이 재시도
        if let token = keychainManager.getItem(forKey: .accessToken), !token.isEmpty, failedAuthorization != "Bearer \(token)" { return }
        guard let refreshToken = keychainManager.getItem(forKey: .refreshToken), !refreshToken.isEmpty else { throw TokenRefreshError.missingRefreshToken }

        let task = Task { try await self.performRefresh(refreshToken: refreshToken) }
        refreshTask = task
        defer { refreshTask = nil }
        try await task.value
    }

    private func performRefresh(refreshToken: String) async throws {
        let api = APIRouter.tokenRefresh(TokenRefreshRequest(refreshToken: refreshToken))
        let response = await session.request(api.baseURL + api.path, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers)
            .validate(statusCode: 200..<300)
            .serializingDecodable(APIResponse<TokenRefreshResponse>.self)
            .response

        switch response.result {
        case let .success(result):
            guard result.status == "SUCCESS" else { throw APIErrorResponse(message: result.message) }
            guard !result.data.accessToken.isEmpty, !result.data.refreshToken.isEmpty, result.data.tokenType.caseInsensitiveCompare("Bearer") == .orderedSame else { throw TokenRefreshError.invalidTokens }
            // 갱신 중 다른 로그인이나 로그아웃으로 바뀐 인증 정보를 덮어쓰기 방지
            guard keychainManager.getItem(forKey: .refreshToken) == refreshToken else { throw TokenRefreshError.credentialsChanged }
            try saveTokens(result.data)

        case let .failure(error):
            if let statusCode = response.response?.statusCode, (500..<600).contains(statusCode) {
                throw APIErrorResponse(message: "일시적인 오류가 발생했어요.\n잠시 후 다시 시도해 주세요.")
            }
            if let data = response.data, let serverError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) { throw serverError }
            throw error
        }
    }

    private func saveTokens(_ tokens: TokenRefreshResponse) throws {
        let previousAccessToken = keychainManager.getItem(forKey: .accessToken)
        guard keychainManager.saveItem(item: tokens.accessToken, forKey: .accessToken) else { throw TokenRefreshError.saveFailed }
        guard keychainManager.saveItem(item: tokens.refreshToken, forKey: .refreshToken) else {
            if let previousAccessToken { _ = keychainManager.saveItem(item: previousAccessToken, forKey: .accessToken) }
            else { _ = keychainManager.deleteItem(forKey: .accessToken) }
            throw TokenRefreshError.saveFailed
        }
    }
}

private enum TokenRefreshError: LocalizedError {
    case missingRefreshToken, invalidTokens, credentialsChanged, saveFailed

    var errorDescription: String? {
        switch self {
        case .missingRefreshToken: "로그인 정보가 없어요. 다시 로그인해 주세요."
        case .invalidTokens: "로그인 갱신 정보를 받지 못했어요. 다시 로그인해 주세요."
        case .credentialsChanged: "로그인 정보가 변경됐어요. 다시 시도해 주세요."
        case .saveFailed: "로그인 정보를 안전하게 저장하지 못했어요. 다시 시도해 주세요."
        }
    }
}
