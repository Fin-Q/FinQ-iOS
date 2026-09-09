//
//  LoginFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LoginFeature {
    @Dependency(\.loginUseCase) private var loginUseCase

    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var isLoading: Bool = false
        var loginErrorMessage: String?

        var isLoginButtonEnabled: Bool {
            return !isLoading && !email.replacingOccurrences(of: " ", with: "").isEmpty && !password.replacingOccurrences(of: " ", with: "").isEmpty
        }
    }
    
    enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case didAppear
        case loginButtonTapped
        case loginSucceeded(isOnboardingCompleted: Bool)
        case loginFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case loginSucceeded(isOnboardingCompleted: Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailChanged(let value):
                state.email = value
                return .none
                
            case .passwordChanged(let value):
                state.password = value
                return .none
                
            case .didAppear:
                return .none

            case .loginButtonTapped:
                guard state.isLoginButtonEnabled else { return .none }

                let email = state.email
                let password = state.password

                state.isLoading = true
                state.loginErrorMessage = nil

                return .run { send in
                    do {
                        let result = try await loginUseCase.login(email: email, password: password)
                        guard !Task.isCancelled else { return }

                        await send(.loginSucceeded(isOnboardingCompleted: result.isOnboardingCompleted))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.loginFailed(error.localizedDescription))
                    }
                }

            case let .loginSucceeded(isOnboardingCompleted):
                state.isLoading = false
                state.loginErrorMessage = nil
                return .send(.delegate(.loginSucceeded(isOnboardingCompleted: isOnboardingCompleted)))

            case let .loginFailed(message):
                state.isLoading = false
                state.loginErrorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.loginErrorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
