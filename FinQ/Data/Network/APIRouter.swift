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
    case logout

    //MARK: - Onboarding
    case onboardingStatus
    case saveInterests(InterestSelectionRequest)
    case completeOnboarding

    //MARK: - Home
    case home
    case profileImage
    case streakCalendar(month: String?)
    case streakStatus

    //MARK: - MyPage
    case myPage
    case updateInterests(InterestSelectionRequest)
    case updateProfileImage(ProfileImageUpdateRequest)
    case updateNickname(NicknameUpdateRequest)
    case withdraw

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
        case .logout: return "/auth/logout"
        
        case .onboardingStatus: return "/users/me/onboarding"
        case .saveInterests: return "/users/me/interests"
        case .completeOnboarding: return "/users/me/onboarding/complete"
        case .home: return "/home"
        case .profileImage: return "/users/me/profile-image"
        case .streakCalendar: return "/streak/calendar"
        case .streakStatus: return "/streak/status"
        case .myPage: return "/users/me"
        case .updateInterests: return "/users/me/interests"
        case .updateProfileImage: return "/users/me/profile-image"
        case .updateNickname: return "/users/me/nickname"
        case .withdraw: return "/users/me"
        case .knowledgeMap: return "/knowledge-map"
        case .categoryDetail(let categoryCode): return "/categories/\(categoryCode)"
        case .advancedQuiz(let categoryID): return "/categories/\(categoryID)/quiz"
        case let .submitAdvancedQuizAnswer(categoryID, questionID, _): return "/categories/\(categoryID)/quiz/questions/\(questionID)/answers"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .registerFCMToken, .logout, .saveInterests, .submitAdvancedQuizAnswer:
            return .post
        case .completeOnboarding, .updateProfileImage, .updateNickname:
            return .patch
        case .updateInterests:
            return .put
        case .withdraw:
            return .delete
        case .onboardingStatus, .knowledgeMap, .categoryDetail, .advancedQuiz, .home, .profileImage, .streakCalendar, .streakStatus, .myPage:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .registerFCMToken, .logout, .onboardingStatus, .saveInterests, .completeOnboarding, .knowledgeMap, .categoryDetail, .home, .profileImage, .streakCalendar, .streakStatus, .advancedQuiz, .submitAdvancedQuizAnswer, .myPage, .updateInterests, .updateProfileImage, .updateNickname, .withdraw:
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    var encoding: any ParameterEncoding {
        switch self {
        case .signUp, .login, .appleLogin, .kakaoLogin, .tokenRefresh, .sendPasswordResetVerification, .verificationCodeConfirm, .passwordReset, .registerFCMToken, .logout, .saveInterests, .completeOnboarding, .submitAdvancedQuizAnswer, .updateInterests, .updateProfileImage, .updateNickname:
            return JSONEncoding.default
        
        case .onboardingStatus, .knowledgeMap, .categoryDetail, .home, .profileImage, .streakCalendar, .streakStatus, .advancedQuiz, .myPage, .withdraw:
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

        case .updateInterests(let request):
            return ["interestTopicIds": request.interestTopicIds]

        case .updateProfileImage(let request):
            return ["profileImageCode": request.profileImageCode]

        case .updateNickname(let request):
            return ["nickname": request.nickname]

        case let .streakCalendar(month):
            return month.map { ["month": $0] }
            
        case .submitAdvancedQuizAnswer(_, _, let request):
            return ["selectedOptionId": request.selectedOptionID]

        case .logout, .onboardingStatus, .completeOnboarding, .knowledgeMap, .categoryDetail, .advancedQuiz, .home, .profileImage, .streakStatus, .myPage, .withdraw:
            return nil
        }
    }

    var requiresAuthorization: Bool {
        // 토큰 갱신 및 로그인 API 제외한 모든 API에 인증 인터셉터를 적용
        switch self {
        case .tokenRefresh,
                .signUp,
                .login,
                .appleLogin,
                .kakaoLogin,
                .sendPasswordResetVerification,
                .verificationCodeConfirm,
                .passwordReset:
            return false
        default:
            return true
        }
    }
}
