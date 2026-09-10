//
//  APIRouter.swift
//  FinQ
//
//  Created by 권대윤 on 8/30/26.
//

import Foundation
import Alamofire

enum APIRouter: Sendable {
    
    //MARK: - Auth
    case signUp(SignUpRequest)
    case login(LoginRequest)
    case appleLogin(AppleLoginRequest)
    case sendPasswordResetVerification(PasswordResetVerificationRequest)
}

extension APIRouter {
    var baseURL: String {
        return "http://finq-prod-public-alb-108906608.ap-northeast-2.elb.amazonaws.com/api/v1"
    }
    
    var path: String {
        switch self {
        case .signUp: return "/auth/sign-up"
        case .login: return "/auth/login"
        case .appleLogin: return "/auth/social/apple"
        case .sendPasswordResetVerification: return "/auth/password-reset/verifications"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .login, .appleLogin, .sendPasswordResetVerification:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .signUp, .login, .appleLogin, .sendPasswordResetVerification:
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    var encoding: any ParameterEncoding {
        switch self {
        case .signUp, .login, .appleLogin, .sendPasswordResetVerification:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .signUp(let request):
            return [
                "email": request.email,
                "password": request.password,
                "nickname": request.nickname,
                "agreements": request.agreements.map { agreement -> Parameters in
                    return [
                        "agreementCode": agreement.agreementCode,
                        "version": agreement.version,
                        "agreed": agreement.agreed
                    ]
                }
            ]
            
        case .login(let request):
            return [
                "email": request.email,
                "password": request.password
            ]

        case .sendPasswordResetVerification(let request):
            return ["loginId": request.loginID]

        case .appleLogin(let request):
            return [
                "identityToken": request.identityToken,
                "authorizationCode": request.authorizationCode,
                "nonce": request.nonce,
                "nickname": request.nickname,
                "agreements": request.agreements.map { ["agreementCode": $0.agreementCode, "version": $0.version, "agreed": $0.agreed] as Parameters }
            ]
        }
    }
}
