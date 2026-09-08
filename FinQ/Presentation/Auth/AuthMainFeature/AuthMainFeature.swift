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
    }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
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
