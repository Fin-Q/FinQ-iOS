//
//  ContentLearningCompletionFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContentLearningCompletionFeature {
    @ObservableState
    struct State: Equatable {
        let completionResult: ContentCompletionResult?
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
