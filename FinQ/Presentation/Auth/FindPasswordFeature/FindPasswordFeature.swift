//
//  FindPasswordFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/7/26.
//

import Foundation
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
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailChanged(let value):
                state.email = value
                return .none
            }
        }
    }
}
