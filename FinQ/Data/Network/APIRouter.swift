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
    case tokenRefresh(TokenRefreshRequest)
    case sendPasswordResetVerification(PasswordResetVerificationRequest)

    //MARK: - Onboarding
    case saveInterests(InterestSelectionRequest)
    case completeOnboarding

    //MARK: - User
    case fetchUserMe

    //MARK: - Home
    case fetchHome

    //MARK: - Streak
    case fetchStreakStatus
    case fetchStreakCalendar(String?)

    //MARK: - Reward
    case fetchRewardStatus

    //MARK: - Profile
    case patchNickname(String)
    case patchProfileImage(String)
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
        case .tokenRefresh: return "/auth/token/refresh"
        case .sendPasswordResetVerification: return "/auth/password-reset/verifications"
        case .saveInterests: return "/users/me/interests"
        case .completeOnboarding: return "/users/me/onboarding/complete"
        case .fetchUserMe: return "/users/me"
        case .fetchHome: return "/home"
        case .fetchStreakStatus: return "/streak/status"
        case .fetchStreakCalendar: return "/streak/calendar"
        case .fetchRewardStatus: return "/rewards/status"
        case .patchNickname: return "/users/me/nickname"
        case .patchProfileImage: return "/users/me/profile-image"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .login, .appleLogin, .tokenRefresh, .sendPasswordResetVerification, .saveInterests:
            return .post
        case .completeOnboarding, .patchNickname, .patchProfileImage:
            return .patch
        case .fetchUserMe, .fetchHome, .fetchStreakStatus, .fetchStreakCalendar, .fetchRewardStatus:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .signUp, .login, .appleLogin, .tokenRefresh, .sendPasswordResetVerification, .saveInterests, .completeOnboarding, .patchNickname, .patchProfileImage:
            return [
                "Content-Type": "application/json"
            ]
        case .fetchUserMe, .fetchHome, .fetchStreakStatus, .fetchStreakCalendar, .fetchRewardStatus:
            return nil
        }
    }

    var encoding: any ParameterEncoding {
        switch self {
        case .signUp, .login, .appleLogin, .tokenRefresh, .sendPasswordResetVerification, .saveInterests, .completeOnboarding, .patchNickname, .patchProfileImage:
            return JSONEncoding.default
        case .fetchUserMe, .fetchHome, .fetchStreakStatus, .fetchStreakCalendar, .fetchRewardStatus:
            return URLEncoding.default
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

        case .tokenRefresh(let request):
            return ["refreshToken": request.refreshToken]

        case .appleLogin(let request):
            return [
                "identityToken": request.identityToken,
                "authorizationCode": request.authorizationCode,
                "nonce": request.nonce,
                "nickname": request.nickname,
                "agreements": request.agreements.map { ["agreementCode": $0.agreementCode, "version": $0.version, "agreed": $0.agreed] as Parameters }
            ]

        case .saveInterests(let request):
            return ["interestTopicIds": request.interestTopicIds]

        case .fetchUserMe, .fetchHome, .fetchStreakStatus, .fetchRewardStatus, .completeOnboarding:
            return nil
        case .patchNickname(let nickname):
            return ["nickname": nickname]
        case .patchProfileImage(let code):
            return ["profileImageCode": code]
        case .fetchStreakCalendar(let month):
            guard let month else { return nil }
            return ["month": month]
        }
    }

    var requiresAuthorization: Bool {
        // 토큰 갱신 API를 제외한 모든 API에 인증 인터셉터를 적용
        switch self {
        case .tokenRefresh:
            return false
        default:
            return true
        }
    }
}
