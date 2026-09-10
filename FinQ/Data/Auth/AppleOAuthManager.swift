//
//  AppleOAuthManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/1/26.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Security

struct AppleOAuthResult: Sendable {
    let userIdentifier: String
    let identityToken: String
    let authorizationCode: String
    let fullName: String
    let email: String
    let rawNonce: String
    let issuedAt: Date
}

enum AppleOAuthError: LocalizedError, Sendable {
    case requestAlreadyInProgress
    case invalidCredential
    case invalidIdentityToken
    case invalidAuthorizationCode
    case missingIdentityToken
    case missingAuthorizationCode
    case missingNonce
    case missingPresentationAnchor

    var errorDescription: String? {
        switch self {
        case .requestAlreadyInProgress: "Apple 로그인이 이미 진행 중이에요. 잠시 기다려 주세요."
        case .missingPresentationAnchor: "Apple 로그인 화면을 열지 못했어요. 다시 시도해 주세요."
        default: "Apple 인증 정보를 받지 못했어요. 다시 시도해 주세요."
        }
    }
}

@MainActor
protocol AppleOAuthManagerProtocol: AnyObject {
    func signIn() async throws -> AppleOAuthResult
}

@MainActor
final class AppleOAuthManager: NSObject, AppleOAuthManagerProtocol {
    
    static let shared = AppleOAuthManager()
    private override init() { }
    
    private var continuation: CheckedContinuation<AppleOAuthResult, any Error>?
    private var authorizationController: ASAuthorizationController?
    private var requestID: UUID?
    private var currentRawNonce: String?
    private var presentationWindow: UIWindow?
    
    func signIn() async throws -> AppleOAuthResult {
        guard continuation == nil else {
            throw AppleOAuthError.requestAlreadyInProgress
        }

        guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene })
            .filter({ $0.activationState == .foregroundActive }).flatMap(\.windows).first(where: \.isKeyWindow)
        else { throw AppleOAuthError.missingPresentationAnchor }

        let requestID = UUID()
        let rawNonce = try generateNonce()

        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                self.requestID = requestID
                self.currentRawNonce = rawNonce
                self.presentationWindow = window

                let request = ASAuthorizationAppleIDProvider().createRequest()
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(rawNonce)

                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self

                self.authorizationController = authorizationController
                authorizationController.performRequests()
            }
        } onCancel: {
            Task { @MainActor [weak self] in
                guard let self, self.requestID == requestID else { return }
                let controller = self.authorizationController
                self.finish(with: .failure(CancellationError()))
                controller?.cancel()
            }
        }
    }
    
    private func finish(with result: Result<AppleOAuthResult, any Error>) {
        guard let continuation else { return }
        
        self.continuation = nil
        authorizationController = nil
        requestID = nil
        currentRawNonce = nil
        presentationWindow = nil
        continuation.resume(with: result)
    }

    private func generateNonce() throws -> String {
        var bytes = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        guard status == errSecSuccess else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil) }
        return bytes.map { String(format: "%02x", $0) }.joined()
    }

    private func sha256(_ value: String) -> String {
        SHA256.hash(data: Data(value.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}

extension AppleOAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard controller === authorizationController else { return }
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            finish(with: .failure(AppleOAuthError.invalidCredential))
            return
        }

        guard let identityTokenData = credential.identityToken else {
            finish(with: .failure(AppleOAuthError.missingIdentityToken))
            return
        }

        guard let identityToken = String(data: identityTokenData, encoding: .utf8), !identityToken.isEmpty else {
            finish(with: .failure(AppleOAuthError.invalidIdentityToken))
            return
        }

        guard let authorizationCodeData = credential.authorizationCode else {
            finish(with: .failure(AppleOAuthError.missingAuthorizationCode))
            return
        }

        guard let authorizationCode = String(data: authorizationCodeData, encoding: .utf8), !authorizationCode.isEmpty else {
            finish(with: .failure(AppleOAuthError.invalidAuthorizationCode))
            return
        }
        guard let rawNonce = currentRawNonce else {
            finish(with: .failure(AppleOAuthError.missingNonce))
            return
        }

        let combinedFullName = [credential.fullName?.familyName, credential.fullName?.givenName].compactMap { $0 }.joined().filter { !$0.isWhitespace }

        let result = AppleOAuthResult(
            userIdentifier: credential.user,
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: combinedFullName,
            email: credential.email ?? "",
            rawNonce: rawNonce,
            issuedAt: Date()
        )
        finish(with: .success(result))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        guard controller === authorizationController else { return }
        if let error = error as? ASAuthorizationError, error.code == .canceled {
            finish(with: .failure(CancellationError()))
        } else {
            finish(with: .failure(error))
        }
    }
}

extension AppleOAuthManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presentationWindow ?? ASPresentationAnchor()
    }
}
