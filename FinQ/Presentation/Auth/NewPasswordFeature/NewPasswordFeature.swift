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
    @ObservableState
    struct State: Equatable {
        var password: String = ""
        var passwordCheck: String = ""
        var shouldShowPasswordValidation: Bool = false
        var shouldShowPasswordCheckValidation: Bool = false
        
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
            return isPasswordValid && !passwordCheck.isEmpty && password == passwordCheck
        }
        
        var isPasswordCheckMismatch: Bool {
            return !passwordCheck.isEmpty && password != passwordCheck
        }

        var isFormValid: Bool {
            return isPasswordValid && isPasswordCheckValid
        }
    }
    
    enum Action {
        case passwordChanged(String)
        case passwordCheckChanged(String)
        case passwordEditingEnded
        case passwordCheckEditingEnded
        case nextButtonTapped
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
                guard state.isFormValid else { return .none }
                return .send(.delegate(.pushToPasswordResetDoneView))

            case .delegate:
                return .none
            }
        }
    }
}
