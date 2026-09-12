//
//  NewPasswordFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NewPasswordFeature {
    @Dependency(\.passwordResetUseCase) private var passwordResetUseCase

    @ObservableState
    struct State: Equatable {
        var passwordResetToken: String = ""
        var password: String = ""
        var passwordCheck: String = ""
        var shouldShowPasswordValidation: Bool = false
        var shouldShowPasswordCheckValidation: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
        
        var isPasswordValid: Bool {
            let hasEnglishLetter = password.range(of: "[A-Za-z]", options: .regularExpression) != nil
            let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
            let specialCharacters = CharacterSet.punctuationCharacters.union(.symbols)
            let hasSpecialCharacter = password.rangeOfCharacter(from: specialCharacters) != nil
            
            return (8...72).contains(password.count)
            && hasEnglishLetter
            && hasNumber
            && hasSpecialCharacter
        }
        
        var isPasswordCheckValid: Bool {
            return isPasswordValid && !passwordCheck.isEmpty && password == passwordCheck
        }
        
        var isPasswordCheckMismatch: Bool {
            return !passwordCheck.isEmpty && password != passwordCheck
        }

        var isFormValid: Bool {
            return isPasswordValid && isPasswordCheckValid
        }

        var isNextButtonEnabled: Bool {
            return isFormValid && !isLoading && !passwordResetToken.isEmpty
        }
    }
    
    enum Action {
        case passwordChanged(String)
        case passwordCheckChanged(String)
        case passwordEditingEnded
        case passwordCheckEditingEnded
        case nextButtonTapped
        case passwordResetSucceeded
        case passwordResetFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate {
            case pushToPasswordResetDoneView
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .passwordChanged(let value):
                state.password = value
                state.shouldShowPasswordValidation = false
                state.shouldShowPasswordCheckValidation = false
                return .none
                
            case .passwordCheckChanged(let value):
                state.passwordCheck = value
                state.shouldShowPasswordCheckValidation = false
                return .none

            case .passwordEditingEnded:
                state.shouldShowPasswordValidation = true
                return .none

            case .passwordCheckEditingEnded:
                state.shouldShowPasswordCheckValidation = true
                return .none

            case .nextButtonTapped:
                state.shouldShowPasswordValidation = true
                state.shouldShowPasswordCheckValidation = true
                guard state.isNextButtonEnabled else { return .none }

                let passwordResetToken = state.passwordResetToken
                let newPassword = state.password
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await passwordResetUseCase.resetPassword(passwordResetToken: passwordResetToken, newPassword: newPassword)
                        guard !Task.isCancelled else { return }

                        await send(.passwordResetSucceeded)
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.passwordResetFailed(error.localizedDescription))
                    }
                }

            case .passwordResetSucceeded:
                state.isLoading = false
                return .send(.delegate(.pushToPasswordResetDoneView))

            case let .passwordResetFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
