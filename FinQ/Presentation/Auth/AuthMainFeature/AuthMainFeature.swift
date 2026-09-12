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
    @Dependency(\.appleOAuthUseCase) private var appleOAuthUseCase
    @Dependency(\.kakaoOAuthUseCase) private var kakaoOAuthUseCase

    private enum CancelID { case appleAuthorization, kakaoAuthorization }

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
        var isSocialAuthorizing: Bool = false
        var socialLoginErrorMessage: String?
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case loginButtonTapped
        case signUpButtonTapped
        case findPasswordButtonTapped
        case kakaoLoginButtonTapped
        case kakaoLoginSucceeded(KakaoLoginResult)
        case kakaoLoginFailed(String)
        case kakaoLoginCancelled
        case appleLoginButtonTapped
        case appleLoginSucceeded(AppleLoginResult)
        case appleLoginFailed(String)
        case appleLoginCancelled
        case alertOKButtonTapped
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case loginSucceeded(isOnboardingCompleted: Bool)
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

            case .kakaoLoginButtonTapped:
                guard !state.isSocialAuthorizing, state.path.isEmpty else { return .none }
                state.isSocialAuthorizing = true
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
                guard state.isSocialAuthorizing else { return .none }
                state.isSocialAuthorizing = false
                guard state.path.isEmpty else { return .none }

                if result.isNewUser {
                    state.path.append(.signUpTerms(SignUpTermsFeature.State(flow: .kakao)))
                    return .none
                }

                return .send(.delegate(.loginSucceeded(isOnboardingCompleted: result.isOnboardingCompleted)))

            case let .kakaoLoginFailed(message):
                state.isSocialAuthorizing = false
                state.socialLoginErrorMessage = message
                return .none

            case .kakaoLoginCancelled:
                state.isSocialAuthorizing = false
                return .none

            case .appleLoginButtonTapped:
                guard !state.isSocialAuthorizing, state.path.isEmpty else { return .none }
                state.isSocialAuthorizing = true
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
                guard state.isSocialAuthorizing else { return .none }
                state.isSocialAuthorizing = false
                guard state.path.isEmpty else { return .none }

                if result.isNewUser {
                    state.path.append(.signUpTerms(SignUpTermsFeature.State(flow: .apple)))
                    return .none
                }

                return .send(.delegate(.loginSucceeded(isOnboardingCompleted: result.isOnboardingCompleted)))

            case let .appleLoginFailed(message):
                state.isSocialAuthorizing = false
                state.socialLoginErrorMessage = message
                return .none

            case .appleLoginCancelled:
                state.isSocialAuthorizing = false
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
                state.path.append(.signUpDone(SignUpDoneFeature.State(isOnboardingCompleted: false)))
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

            case let .path(.element(id: id, action: .login(.delegate(.loginSucceeded(isOnboardingCompleted))))):
                guard state.path.ids.last == id else { return .none }

                return .send(.delegate(.loginSucceeded(isOnboardingCompleted: isOnboardingCompleted)))
                
            case .path(.popFrom(id: _)):
                // 정리 전에 뒤로 이동했다면 대기 중인 정리를 취소
                state.loginIDPendingCleanup = nil
                return .none
                
            case let .path(.element(id: id, action: .signUpDone(.delegate(.start(isOnboardingCompleted))))):
                guard state.path.ids.last == id else { return .none }

                return .send(.delegate(.loginSucceeded(isOnboardingCompleted: isOnboardingCompleted)))
                
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
