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
    @Reducer
    enum Path {
        case signUpTerms(SignUpTermsFeature)
        case termsDetail(TermsDetailFeature)
        case signUp(SignUpFeature)
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
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case loginButtonTapped
        case signUpButtonTapped
        case findPasswordButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case loginSucceeded
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                state.path.append(.login(LoginFeature.State()))
                return .none
                
            case .signUpButtonTapped:
                state.path.append(.signUpTerms(SignUpTermsFeature.State()))
                return .none
                
            case .findPasswordButtonTapped:
                state.path.append(.findPassword(FindPasswordFeature.State()))
                return .none
                
            case let .path(.element(id: _, action: .signUpTerms(.termRowTapped(term)))):
                state.path.append(.termsDetail(TermsDetailFeature.State(term: term)))
                return .none
                
            case let .path(.element(id: _, action: .termsDetail(.delegate(.agreed(term))))):
                guard let signUpTermsID = state.path.ids.dropLast().last else {
                    return .none
                }
                
                state.path.removeLast()

                return .send(.path(.element(id: signUpTermsID, action: .signUpTerms(.termAgreementChanged(term: term)))))
                
            case .path(.element(id: _, action: .signUpTerms(.delegate(.pushToSignUpView)))):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none
                
            case let .path(.element(id: _, action: .findPassword(.delegate(.pushToEmailVerificationView(email))))):
                state.path.append(.emailVerification(EmailVerificationFeature.State(email: email)))
                return .none
                
            case .path(.element(id: _, action: .emailVerification(.delegate(.pushToNewPasswordView)))):
                state.path.append(.newPassword(NewPasswordFeature.State()))
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
                
            case .path(.popFrom(id: _)):
                // 정리 전에 뒤로 이동했다면 대기 중인 정리를 취소
                state.loginIDPendingCleanup = nil
                return .none
                
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
