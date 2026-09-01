//
//  AppleOAuthManager.swift
//  FinQ
//
//  Created by 권대윤 on 9/1/26.
//

import UIKit
import AuthenticationServices

struct AppleOAuthResult: Sendable {
    let userIdentifier: String
    let identityToken: String
    let authorizationCode: String
    let fullName: String?
    let email: String?
}

enum AppleOAuthError: Error, Sendable {
    case requestAlreadyInProgress
    case invalidCredential
    case invalidIdentityToken
    case invalidAuthorizationCode
    case missingIdentityToken
    case missingAuthorizationCode
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
    
    func signIn() async throws -> AppleOAuthResult {
        guard continuation == nil else {
            throw AppleOAuthError.requestAlreadyInProgress
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            
            self.authorizationController = authorizationController
            authorizationController.performRequests()
        }
    }
    
    private func finish(with result: Result<AppleOAuthResult, any Error>) {
        guard let continuation else { return }
        
        self.continuation = nil
        authorizationController = nil
        continuation.resume(with: result)
    }
}

extension AppleOAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            finish(with: .failure(AppleOAuthError.invalidCredential))
            return
        }

        guard let identityTokenData = credential.identityToken else {
            finish(with: .failure(AppleOAuthError.missingIdentityToken))
            return
        }

        guard let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            finish(with: .failure(AppleOAuthError.invalidIdentityToken))
            return
        }

        guard let authorizationCodeData = credential.authorizationCode else {
            finish(with: .failure(AppleOAuthError.missingAuthorizationCode))
            return
        }

        guard let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            finish(with: .failure(AppleOAuthError.invalidAuthorizationCode))
            return
        }
        
        let combinedName = [credential.fullName?.familyName, credential.fullName?.givenName].compactMap { $0 }.joined().filter { !$0.isWhitespace }

        let fullName = combinedName.isEmpty ? nil : combinedName
        let email = credential.email

        let result = AppleOAuthResult(
            userIdentifier: credential.user,
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: fullName,
            email: email
        )
        finish(with: .success(result))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        finish(with: .failure(error))
    }
}

extension AppleOAuthManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.activationState == .foregroundActive })
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
        else {
            AppLogger.shared.log("window not found", level: .error)
            fatalError()
        }
        return window
    }
}
