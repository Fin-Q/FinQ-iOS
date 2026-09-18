//
//  AdvancedQuizCompletionFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdvancedQuizCompletionFeature {
    @ObservableState
    struct State: Equatable {
        let categoryResult: AdvancedQuizCategoryResult?
    }

    enum Action {
        case completeButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .completeButtonTapped:
                return .send(.delegate(.completed))

            case .delegate:
                return .none
            }
        }
    }
}
