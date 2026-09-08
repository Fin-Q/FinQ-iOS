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
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var isLoginButtonEnabled: Bool {
            return !email.replacingOccurrences(of: " ", with: "").isEmpty && !password.replacingOccurrences(of: " ", with: "").isEmpty
        }
    }
    
    enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case didAppear
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
            }
        }
    }
}
