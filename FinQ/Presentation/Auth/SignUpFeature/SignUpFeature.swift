//
//  SignUpFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignUpFeature {
    @Dependency(\.signUpUseCase) private var signUpUseCase

    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var passwordCheck: String = ""
        var shouldShowEmailValidation: Bool = false
        var shouldShowPasswordValidation: Bool = false
        var shouldShowPasswordCheckValidation: Bool = false
        var isLoading: Bool = false
        var signUpErrorMessage: String?

        var isEmailValid: Bool {
            email.range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil
        }
        
        var isPasswordValid: Bool {
            let hasEnglishLetter = password.range(of: "[A-Za-z]", options: .regularExpression) != nil
            let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
            let specialCharacters = CharacterSet.punctuationCharacters.union(.symbols)
            let hasSpecialCharacter = password.rangeOfCharacter(from: specialCharacters) != nil
            
            return password.count >= 8
            && hasEnglishLetter
            && hasNumber
            && hasSpecialCharacter
        }
        
        var isPasswordCheckValid: Bool {
            isPasswordValid
            && !passwordCheck.isEmpty
            && password == passwordCheck
        }
        
        var isPasswordCheckMismatch: Bool {
            !passwordCheck.isEmpty && password != passwordCheck
        }

        var isFormValid: Bool {
            isEmailValid
            && isPasswordValid
            && isPasswordCheckValid
        }
        
    }

    enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case passwordCheckChanged(String)
        case emailEditingEnded
        case passwordEditingEnded
        case passwordCheckEditingEnded
        case nextButtonTapped
        case signUpSucceeded
        case signUpFailed(String)
        case alertOKButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case pushToSignUpDoneView
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                state.shouldShowEmailValidation = false
                return .none
                
            case let .passwordChanged(password):
                state.password = password
                state.shouldShowPasswordValidation = false
                state.shouldShowPasswordCheckValidation = false
                return .none
                
            case let .passwordCheckChanged(passwordCheck):
                state.passwordCheck = passwordCheck
                state.shouldShowPasswordCheckValidation = false
                return .none

            case .emailEditingEnded:
                state.shouldShowEmailValidation = true
                return .none

            case .passwordEditingEnded:
                state.shouldShowPasswordValidation = true
                return .none

            case .passwordCheckEditingEnded:
                state.shouldShowPasswordCheckValidation = true
                return .none

            case .nextButtonTapped:
                state.shouldShowEmailValidation = true
                state.shouldShowPasswordValidation = true
                state.shouldShowPasswordCheckValidation = true

                guard state.isFormValid, !state.isLoading else {
                    return .none
                }

                let email = state.email
                let password = state.password
                let nickname = Self.makeRandomNickname()

                state.isLoading = true
                state.signUpErrorMessage = nil

                return .run { send in
                    do {
                        _ = try await signUpUseCase.signUp(email: email, password: password, nickname: nickname)
                        await send(.signUpSucceeded)
                    } catch {
                        await send(.signUpFailed(error.localizedDescription))
                    }
                }

            case .signUpSucceeded:
                state.isLoading = false
                return .send(.delegate(.pushToSignUpDoneView))

            case let .signUpFailed(message):
                state.isLoading = false
                state.signUpErrorMessage = message
                return .none
                
            case .alertOKButtonTapped:
                state.signUpErrorMessage = nil
                return .none
                
            case .delegate:
                return .none
            }
        }
    }

    static func makeRandomNickname() -> String { RandomNicknameGenerator.generate() }
}
