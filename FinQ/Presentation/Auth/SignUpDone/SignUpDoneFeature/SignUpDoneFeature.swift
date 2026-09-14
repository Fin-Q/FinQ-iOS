//
//  SignUpDoneFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SignUpDoneFeature {
    @ObservableState
    struct State: Equatable {
        var isOnboardingCompleted: Bool = false
    }
    
    enum Action {
        case startButtonTapped
        case delegate(Delegate)
        enum Delegate {
            case start(isOnboardingCompleted: Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                return .send(.delegate(.start(isOnboardingCompleted: state.isOnboardingCompleted)))
                
            case .delegate:
                return .none
            }
        }
    }
}
