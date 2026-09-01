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
    @ObservableState
    struct State: Equatable {
         
    }
    
    enum Action {
        case loginButtonTapped
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
                
            case .delegate:
                 return .none
            }
        }
    }
}
