//
//  AdvancedQuizCompletionSummaryFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdvancedQuizCompletionSummaryFeature {
    @ObservableState
    struct State: Equatable {
        let quiz: AdvancedQuiz
        let categoryResult: AdvancedQuizCategoryResult?
    }

    enum Action {
        case nextButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completionRequested(AdvancedQuizCategoryResult?)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .send(.delegate(.completionRequested(state.categoryResult)))

            case .delegate:
                return .none
            }
        }
    }
}
