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
    case kakaoLogin(KakaoLoginRequest)
    case tokenRefresh(TokenRefreshRequest)
    case sendPasswordResetVerification(PasswordResetVerificationRequest)
    case verificationCodeConfirm(VerificationCodeConfirmRequest)
    case passwordReset(PasswordResetConfirmRequest)
    case registerFCMToken(RegisterFCMTokenRequest)

    //MARK: - Onboarding
    case onboardingStatus
    case saveInterests(InterestSelectionRequest)
    case completeOnboarding

    //MARK: - Home
    case home
    case profileImage
    case streakCalendar(month: String?)
    case streakStatus

    //MARK: - KnowledgeMap
    case knowledgeMap
    case categoryDetail(String)
    case advancedQuiz(Int)
    case submitAdvancedQuizAnswer(categoryID: Int, questionID: Int, request: AdvancedQuizAnswerRequest)
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
        case .kakaoLogin: return "/auth/social/kakao"
        case .tokenRefresh: return "/auth/token/refresh"
        case .sendPasswordResetVerification: return "/auth/password-reset/verifications"
        case .verificationCodeConfirm: return "/auth/password-reset/verifications/confirm"
        case .passwordReset: return "/auth/password-reset"
        case .registerFCMToken(let request): return "/users/me/push-tokens/\(request.deviceID)"
        
        case .onboardingStatus: return "/users/me/onboarding"
        case .saveInterests: return "/users/me/interests"
        case .completeOnboarding: return "/users/me/onboarding/complete"
        case .home: return "/home"
        case .profileImage: return "/users/me/profile-image"
        case .streakCalendar: return "/streak/calendar"
        case .streakStatus: return "/streak/status"
        case .knowledgeMap: return "/knowledge-map"
        case .categoryDetail(let categoryCode): return "/categories/\(categoryCode)"
        case .advancedQuiz(let categoryID): return "/categories/\(categoryID)/quiz"
        case let .submitAdvancedQuizAnswer(categoryID, questionID, _): return "/categories/\(categoryID)/quiz/questions/\(questionID)/answers"
        }
    }
    
    var method: HTTPMethod {
        switch self {
<<<<<<< HEAD
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .registerFCMToken ,.saveInterests:
            return .post
        case .completeOnboarding:
            return .patch
        case .onboardingStatus, .knowledgeMap, .categoryDetail, .home, .profileImage, .streakCalendar, .streakStatus:
=======
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .saveInterests, .submitAdvancedQuizAnswer:
            return .post
        case .completeOnboarding:
            return .patch
        case .knowledgeMap, .categoryDetail, .advancedQuiz:
>>>>>>> feature/advanced-quiz
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
<<<<<<< HEAD
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .registerFCMToken, .onboardingStatus, .saveInterests, .completeOnboarding, .knowledgeMap, .categoryDetail, .home, .profileImage, .streakCalendar, .streakStatus:
=======
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .saveInterests, .completeOnboarding, .knowledgeMap, .categoryDetail, .advancedQuiz, .submitAdvancedQuizAnswer:
>>>>>>> feature/advanced-quiz
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    var encoding: any ParameterEncoding {
        switch self {
<<<<<<< HEAD
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .registerFCMToken, .saveInterests, .completeOnboarding:
            return JSONEncoding.default
        case .onboardingStatus, .knowledgeMap, .categoryDetail, .home, .profileImage, .streakCalendar, .streakStatus:
=======
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .saveInterests, .completeOnboarding, .submitAdvancedQuizAnswer:
            return JSONEncoding.default
        case .knowledgeMap, .categoryDetail, .advancedQuiz:
>>>>>>> feature/advanced-quiz
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

        case .verificationCodeConfirm(let request):
            return [
                "verificationId": request.verificationId,
                "verificationCode": request.verificationCode
            ]

        case .passwordReset(let request):
            return [
                "passwordResetToken": request.passwordResetToken,
                "newPassword": request.newPassword
            ]

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

        case .kakaoLogin(let request):
            return [
                "kakaoAccessToken": request.kakaoAccessToken,
                "nickname": request.nickname,
                "agreements": request.agreements.map { ["agreementCode": $0.agreementCode, "version": $0.version, "agreed": $0.agreed] as Parameters }
            ]
            
        case .registerFCMToken(let request):
            return [
                "fcmToken": request.fcmToken,
                "platform": request.platform
            ]

        case .saveInterests(let request):
            return ["interestTopicIds": request.interestTopicIds]

        case let .streakCalendar(month):
            return month.map { ["month": $0] }
            
        case .submitAdvancedQuizAnswer(_, _, let request):
            return ["selectedOptionId": request.selectedOptionID]

        case .onboardingStatus, .completeOnboarding, .knowledgeMap, .categoryDetail, .advancedQuiz, .home, .profileImage, .streakStatus:
            return nil
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
