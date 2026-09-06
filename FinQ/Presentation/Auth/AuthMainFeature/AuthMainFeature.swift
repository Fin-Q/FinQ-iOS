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
    }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case loginButtonTapped
        case signUpButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case loginSucceeded
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                return .send(.delegate(.loginSucceeded))
                
            case .signUpButtonTapped:
                state.path.append(.signUpTerms(SignUpTermsFeature.State()))
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
