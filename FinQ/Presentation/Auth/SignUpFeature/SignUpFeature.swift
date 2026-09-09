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

    static func makeRandomNickname() -> String {
        let nouns = [
            "금융새싹", "금융고수", "금융박사", "금융천재", "금융요정", "금융대장",
            "투자새싹", "투자초보", "투자고수", "투자박사", "투자천재", "투자요정",
            "저축새싹", "저축고수", "저축박사", "저축천재", "저축요정", "저축대장",
            "경제새싹", "경제고수", "경제박사", "경제천재", "경제요정", "경제대장",
            "절약새싹", "절약고수", "절약박사", "절약천재", "절약요정", "절약대장",
            "자산새싹", "자산고수", "자산박사", "자산천재", "자산요정", "자산대장",
            "주식새싹", "주식고수", "주식박사", "펀드새싹", "펀드고수", "채권새싹",
            "배당고수", "배당박사", "배당부자", "복리고수", "복리박사", "복리달인",
            "예산고수", "예산박사", "소비고수", "소비박사", "신용고수", "신용박사",
            "현금부자", "저축부자", "투자부자", "통장부자", "가계부왕", "돈관리왕",
            "재테크왕", "머니요정", "금고지기", "돈길잡이"
        ]

        let randomNoun = nouns.randomElement()!
        let randomNumber = Int.random(in: 1...999)
        let numberText = String(format: "%03d", randomNumber)

        return randomNoun + numberText
    }
}
