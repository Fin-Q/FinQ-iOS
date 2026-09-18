//
//  AdvancedQuizQuestionFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdvancedQuizQuestionFeature {
    @Dependency(\.knowledgeMapUseCase) private var knowledgeMapUseCase

    @ObservableState
    struct State: Equatable {
        let quiz: AdvancedQuiz
        var questionIndex: Int
        var selectedOptionID: String?
        var isSubmittingAnswer: Bool = false
        var errorMessage: String?
        var answerResult: AdvancedQuizAnswerResultFeature.State?

        init(quiz: AdvancedQuiz, questionIndex: Int = 0, selectedOptionID: String? = nil, isSubmittingAnswer: Bool = false, errorMessage: String? = nil) {
            self.quiz = quiz
            self.questionIndex = questionIndex
            self.selectedOptionID = selectedOptionID
            self.isSubmittingAnswer = isSubmittingAnswer
            self.errorMessage = errorMessage
        }

        var question: AdvancedQuizQuestion? {
            let orderedQuestions = quiz.questions.sorted { $0.order < $1.order }
            return orderedQuestions.indices.contains(questionIndex) ? orderedQuestions[questionIndex] : nil
        }

        var isNextButtonEnabled: Bool { !isSubmittingAnswer && question != nil && selectedOptionID != nil }
    }

    enum Action {
        case optionTapped(String)
        case nextButtonTapped
        case submitAnswerSucceeded(AdvancedQuizAnswerResult)
        case submitAnswerFailed(String)
        case alertOKButtonTapped
        case answerResult(AdvancedQuizAnswerResultFeature.Action)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completionSummaryRequested(quiz: AdvancedQuiz, categoryResult: AdvancedQuizCategoryResult?)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .optionTapped(optionID):
                guard !state.isSubmittingAnswer, state.question?.options.contains(where: { $0.optionID == optionID }) == true else { return .none }
                state.selectedOptionID = optionID
                return .none

            case .nextButtonTapped:
                guard state.isNextButtonEnabled, let question = state.question, let selectedOptionID = state.selectedOptionID else { return .none }
                let categoryID = state.quiz.categoryID
                state.isSubmittingAnswer = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let result = try await knowledgeMapUseCase.submitAdvancedQuizAnswer(categoryID: categoryID, questionID: question.questionID, selectedOptionID: selectedOptionID)
                        guard !Task.isCancelled else { return }
                        await send(.submitAnswerSucceeded(result))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.submitAnswerFailed(error.localizedDescription))
                    }
                }

            case let .submitAnswerSucceeded(result):
                state.isSubmittingAnswer = false
                guard let question = state.question else { return .none }
                state.answerResult = AdvancedQuizAnswerResultFeature.State(quiz: state.quiz, question: question, questionIndex: state.questionIndex, result: result, presentation: result.correct ? .correct : .incorrect)
                return .none

            case let .submitAnswerFailed(message):
                state.isSubmittingAnswer = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .answerResult(.delegate(.retryRequested)):
                state.answerResult = nil
                state.selectedOptionID = nil
                return .none

            case let .answerResult(.delegate(.nextQuestionRequested(_, questionIndex))):
                state.questionIndex = questionIndex
                state.answerResult = nil
                state.selectedOptionID = nil
                return .none

            case let .answerResult(.delegate(.completionSummaryRequested(quiz, categoryResult))):
                return .send(.delegate(.completionSummaryRequested(quiz: quiz, categoryResult: categoryResult)))

            case .answerResult, .delegate:
                return .none
            }
        }
        .ifLet(\.answerResult, action: \.answerResult) {
            AdvancedQuizAnswerResultFeature()
        }
    }
}
