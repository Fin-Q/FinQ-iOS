//
//  MyPageWithdrawalCompletionFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageWithdrawalCompletionFeature {
    struct State: Equatable { }

    enum Action {
        case confirmButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case confirmed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .confirmButtonTapped:
                return .send(.delegate(.confirmed))

            case .delegate:
                return .none
            }
        }
    }
}
