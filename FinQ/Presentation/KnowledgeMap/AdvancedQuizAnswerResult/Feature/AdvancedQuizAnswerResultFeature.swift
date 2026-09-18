//
//  AdvancedQuizAnswerResultFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdvancedQuizAnswerResultFeature {
    enum Presentation: Equatable {
        case correct
        case incorrect
    }

    @ObservableState
    struct State: Equatable {
        let quiz: AdvancedQuiz
        let question: AdvancedQuizQuestion
        let questionIndex: Int
        let result: AdvancedQuizAnswerResult
        let presentation: Presentation

        var correctOption: AdvancedQuizOption? { question.options.first(where: { $0.optionID == result.correctOptionID }) }
        var correctOptionNumber: Int? { question.options.firstIndex(where: { $0.optionID == result.correctOptionID }).map { $0 + 1 } }
    }

    enum Action {
        case primaryButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case nextQuestionRequested(quiz: AdvancedQuiz, questionIndex: Int)
            case completionSummaryRequested(quiz: AdvancedQuiz, categoryResult: AdvancedQuizCategoryResult?)
            case retryRequested
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .primaryButtonTapped:
                switch state.presentation {
                case .incorrect:
                    return .send(.delegate(.retryRequested))

                case .correct:
                    if state.result.isLastQuestion {
                        return .send(.delegate(.completionSummaryRequested(quiz: state.quiz, categoryResult: state.result.categoryResult)))
                    }

                    let nextQuestionIndex = state.questionIndex + 1
                    guard state.quiz.questions.indices.contains(nextQuestionIndex) else { return .none }
                    return .send(.delegate(.nextQuestionRequested(quiz: state.quiz, questionIndex: nextQuestionIndex)))
                }

            case .delegate:
                return .none
            }
        }
    }
}
