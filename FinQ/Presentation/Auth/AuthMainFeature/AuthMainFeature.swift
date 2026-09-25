//
//  AuthMainFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/31/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthMainFeature {
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.appleOAuthUseCase) private var appleOAuthUseCase
    @Dependency(\.kakaoOAuthUseCase) private var kakaoOAuthUseCase

    private enum CancelID { case appleAuthorization, kakaoAuthorization, kakaoAuthorizationRecovery }

    enum SocialLoginProvider: Equatable {
        case kakao
        case apple
    }

    @Reducer
    enum Path {
        case signUpTerms(SignUpTermsFeature)
        case termsDetail(TermsDetailFeature)
        case signUp(SignUpFeature)
        case signUpDone(SignUpDoneFeature)
        case login(LoginFeature)
        case findPassword(FindPasswordFeature)
        case emailVerification(EmailVerificationFeature)
        case newPassword(NewPasswordFeature)
        case passwordResetDone(PasswordResetDoneFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var loginIDPendingCleanup: StackElementID?
        var authorizingProvider: SocialLoginProvider?
        var didReceiveKakaoLoginCallback: Bool = false
        var socialLoginErrorMessage: String?

        var isSocialAuthorizing: Bool {
            authorizingProvider != nil
        }

        var isLoginLoading: Bool {
            guard let id = path.ids.last, case let .login(loginState) = path[id: id] else { return false }
            return loginState.isLoading
        }
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case loginButtonTapped
        case signUpButtonTapped
        case findPasswordButtonTapped
        case guestModeButtonTapped
        case kakaoLoginButtonTapped
        case kakaoLoginSucceeded(KakaoLoginResult)
        case kakaoLoginFailed(String)
        case kakaoLoginCancelled
        case kakaoLoginCallbackReceived
        case kakaoAuthorizationRecoveryTimedOut
        case appleLoginButtonTapped
        case appleLoginSucceeded(AppleLoginResult)
        case appleLoginFailed(String)
        case appleLoginCancelled
        case alertOKButtonTapped
        case appDidBecomeActive
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case loginSucceeded(OnboardingStatus)
            case guestModeStarted
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                guard !state.isSocialAuthorizing else { return .none }
                state.path.append(.login(LoginFeature.State()))
                return .none
                
            case .signUpButtonTapped:
                guard !state.isSocialAuthorizing else { return .none }
                state.path.append(.signUpTerms(SignUpTermsFeature.State()))
                return .none
                
            case .findPasswordButtonTapped:
                guard !state.isSocialAuthorizing else { return .none }
                state.path.append(.findPassword(FindPasswordFeature.State()))
                return .none
                
            case .guestModeButtonTapped:
                guard !state.isSocialAuthorizing, state.path.isEmpty else { return .none }
                return .send(.delegate(.guestModeStarted))

            case .kakaoLoginButtonTapped:
                guard !state.isSocialAuthorizing, state.path.isEmpty else { return .none }
                state.authorizingProvider = .kakao
                state.didReceiveKakaoLoginCallback = false
                state.socialLoginErrorMessage = nil

                return .run { send in
                    do {
                        let credential = try await kakaoOAuthUseCase.signIn()
                        try Task.checkCancellation()

                        let result = try await kakaoOAuthUseCase.login(credential: credential, nickname: RandomNicknameGenerator.generate())
                        try Task.checkCancellation()
                        await send(.kakaoLoginSucceeded(result))
                    } catch is CancellationError {
                        guard !Task.isCancelled else { return }
                        await send(.kakaoLoginCancelled)
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.kakaoLoginFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.kakaoAuthorization, cancelInFlight: true)

            case let .kakaoLoginSucceeded(result):
                guard state.authorizingProvider == .kakao else { return .none }
                state.authorizingProvider = nil
                state.didReceiveKakaoLoginCallback = false
                guard state.path.isEmpty else { return .none }

                if result.isNewUser {
                    state.path.append(.signUpTerms(SignUpTermsFeature.State(flow: .kakao)))
                    return .none
                }

                return .send(.delegate(.loginSucceeded(result.onboardingStatus)))

            case let .kakaoLoginFailed(message):
                guard state.authorizingProvider == .kakao else { return .none }
                state.authorizingProvider = nil
                state.didReceiveKakaoLoginCallback = false
                state.socialLoginErrorMessage = message
                return .none

            case .kakaoLoginCancelled:
                guard state.authorizingProvider == .kakao else { return .none }
                state.authorizingProvider = nil
                state.didReceiveKakaoLoginCallback = false
                return .none

            case .kakaoLoginCallbackReceived:
                guard state.authorizingProvider == .kakao else { return .none }
                state.didReceiveKakaoLoginCallback = true
                return .cancel(id: CancelID.kakaoAuthorizationRecovery)

            case .appDidBecomeActive:
                guard state.authorizingProvider == .kakao, !state.didReceiveKakaoLoginCallback else { return .none }

                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.kakaoAuthorizationRecoveryTimedOut)
                }
                .cancellable(id: CancelID.kakaoAuthorizationRecovery, cancelInFlight: true)

            case .kakaoAuthorizationRecoveryTimedOut:
                guard state.authorizingProvider == .kakao, !state.didReceiveKakaoLoginCallback else { return .none }
                state.authorizingProvider = nil
                state.didReceiveKakaoLoginCallback = false
                state.socialLoginErrorMessage = "카카오 로그인에 실패했어요.\n네트워크 연결 상태를 확인한 후 다시 시도해 주세요."
                return .cancel(id: CancelID.kakaoAuthorization)

            case .appleLoginButtonTapped:
                guard !state.isSocialAuthorizing, state.path.isEmpty else { return .none }
                state.authorizingProvider = .apple
                state.didReceiveKakaoLoginCallback = false
                state.socialLoginErrorMessage = nil

                return .run { send in
                    do {
                        let credential = try await appleOAuthUseCase.signIn()
                        try Task.checkCancellation()

                        let result = try await appleOAuthUseCase.login(credential: credential, nickname: RandomNicknameGenerator.generate())
                        try Task.checkCancellation()
                        await send(.appleLoginSucceeded(result))
                    } catch is CancellationError {
                        guard !Task.isCancelled else { return }
                        await send(.appleLoginCancelled)
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.appleLoginFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.appleAuthorization, cancelInFlight: true)

            case let .appleLoginSucceeded(result):
                guard state.authorizingProvider == .apple else { return .none }
                state.authorizingProvider = nil
                guard state.path.isEmpty else { return .none }

                if result.isNewUser {
                    state.path.append(.signUpTerms(SignUpTermsFeature.State(flow: .apple)))
                    return .none
                }

                return .send(.delegate(.loginSucceeded(result.onboardingStatus)))

            case let .appleLoginFailed(message):
                guard state.authorizingProvider == .apple else { return .none }
                state.authorizingProvider = nil
                state.socialLoginErrorMessage = message
                return .none

            case .appleLoginCancelled:
                guard state.authorizingProvider == .apple else { return .none }
                state.authorizingProvider = nil
                return .none

            case .alertOKButtonTapped:
                state.socialLoginErrorMessage = nil
                return .none
                
            case let .path(.element(id: id, action: .signUpTerms(.termRowTapped(term)))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.termsDetail(TermsDetailFeature.State(term: term)))
                return .none
                
            case let .path(.element(id: _, action: .termsDetail(.delegate(.agreed(term))))):
                guard let signUpTermsID = state.path.ids.dropLast().last else {
                    return .none
                }
                
                state.path.removeLast()

                return .send(.path(.element(id: signUpTermsID, action: .signUpTerms(.termAgreementChanged(term: term)))))
                
            case let .path(.element(id: id, action: .signUpTerms(.delegate(.pushToSignUpView)))):
                guard state.path.ids.last == id, case let .signUpTerms(terms) = state.path[id: id], terms.flow == .email else { return .none }
                state.path.append(.signUp(SignUpFeature.State()))
                return .none

            case let .path(.element(id: id, action: .signUpTerms(.delegate(.pushToSignUpDoneView)))):
                guard state.path.ids.last == id, case let .signUpTerms(terms) = state.path[id: id], terms.flow != .email else { return .none }
                state.path.append(.signUpDone(SignUpDoneFeature.State()))
                return .none
                
            case let .path(.element(id: id, action: .signUp(.delegate(.pushToSignUpDoneView)))):
                guard state.path.ids.last == id else { return .none }

                state.path.append(.signUpDone(SignUpDoneFeature.State()))
                return .none
                
            case let .path(.element(id: id, action: .findPassword(.delegate(.pushToEmailVerificationView(email, verification))))):
                guard state.path.ids.last == id else { return .none }

                let seconds = max(0, verification.expiresIn)
                let verificationState: EmailVerificationFeature.VerificationState = seconds > 0 ? .progress : .timeout
                state.path.append(.emailVerification(EmailVerificationFeature.State(email: email, verificationID: verification.verificationID, verificationState: verificationState, seconds: seconds, resendAvailableIn: max(0, verification.resendAvailableIn))))
                return .none
                
            case let .path(.element(id: id, action: .emailVerification(.delegate(.pushToNewPasswordView(passwordResetToken))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.newPassword(NewPasswordFeature.State(passwordResetToken: passwordResetToken)))
                return .none

            case .path(.element(id: _, action: .newPassword(.delegate(.pushToPasswordResetDoneView)))):
                state.path.append(.passwordResetDone(PasswordResetDoneFeature.State()))
                return .none
                
            case let .path(.element(id: id, action: .passwordResetDone(.navigateLoginButtonTapped))):
                // 현재 최상위 화면에서 누른 버튼만 처리
                guard state.path.ids.last == id else { return .none }
                
                // 먼저 로그인 화면으로 push
                state.path.append(.login(LoginFeature.State()))
                
                // 이 로그인 화면이 표시 완료되면 이전 화면들을 정리
                state.loginIDPendingCleanup = state.path.ids.last
                return .none
                
            case let .path(.element(id: id, action: .login(.didAppear))):
                // 재설정 완료 화면에서 진입한 로그인만 처리
                guard state.loginIDPendingCleanup == id, state.path.ids.last == id else { return .none }
                
                // 중복 표시 콜백이 와도 다시 정리하지 않도록 초기화
                state.loginIDPendingCleanup = nil
                
                // 마지막 로그인 화면의 상태와 ID는 유지
                if state.path.count > 1 {
                    state.path.removeFirst(state.path.count - 1)
                }
                
                return .none

            case let .path(.element(id: id, action: .login(.delegate(.loginSucceeded(status))))):
                guard state.path.ids.last == id else { return .none }

                return .send(.delegate(.loginSucceeded(status)))
                
            case .path(.popFrom(id: _)):
                // 정리 전에 뒤로 이동했다면 대기 중인 정리를 취소
                state.loginIDPendingCleanup = nil
                return .none
                
            case let .path(.element(id: id, action: .signUpDone(.delegate(.start)))):
                guard state.path.ids.last == id else { return .none }

                return .send(.delegate(.loginSucceeded(OnboardingStatus.interestSelection)))
                
            case .path:
                return .none
                
            case .delegate:
                 return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension AuthMainFeature.Path.State: Equatable {}
