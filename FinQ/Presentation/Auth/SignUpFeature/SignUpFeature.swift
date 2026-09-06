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
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var passwordCheck: String = ""
        var shouldShowEmailValidation: Bool = false
        var shouldShowPasswordValidation: Bool = false
        var shouldShowPasswordCheckValidation: Bool = false

        var isEmailValid: Bool {
            email.range(
                of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#,
                options: .regularExpression
            ) != nil
        }
        
        var isPasswordValid: Bool {
            let hasEnglishLetter = password.range(
                of: "[A-Za-z]",
                options: .regularExpression
            ) != nil
            let hasNumber = password.range(
                of: "[0-9]",
                options: .regularExpression
            ) != nil
            let specialCharacters = CharacterSet.punctuationCharacters.union(.symbols)
            let hasSpecialCharacter = password.rangeOfCharacter(
                from: specialCharacters
            ) != nil
            
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

                guard state.isFormValid else {
                    return .none
                }

                // 회원가입 요청 또는 다음 화면 이동
                return .none
            }
        }
    }
}
