//
//  FindPasswordFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FindPasswordFeature {
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var isSendButtonEnabled: Bool {
            return !email.replacingOccurrences(of: " ", with: "").isEmpty
        }
    }
    
    enum Action {
        case emailChanged(String)
        case sendButtonTapped
        
        case delegate(Delegate)
        enum Delegate {
            case pushToEmailVerificationView(email: String)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailChanged(let value):
                state.email = value
                return .none
                
            case .sendButtonTapped:
                guard state.isSendButtonEnabled else { return .none }
                
                return .run { [email = state.email] send in
                    var transaction = Transaction(animation: nil)
                    transaction.disablesAnimations = true
                    await send(.delegate(.pushToEmailVerificationView(email: email)), transaction: transaction)
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
