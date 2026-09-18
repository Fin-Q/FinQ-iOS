//
//  AdvancedQuizIntroFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdvancedQuizIntroFeature {
    @ObservableState
    struct State: Equatable {
        let quiz: AdvancedQuiz
    }

    enum Action {
        case startButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case advancedQuizQuestionRequested(AdvancedQuiz)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                guard !state.quiz.questions.isEmpty else { return .none }
                return .send(.delegate(.advancedQuizQuestionRequested(state.quiz)))

            case .delegate:
                return .none
            }
        }
    }
}
