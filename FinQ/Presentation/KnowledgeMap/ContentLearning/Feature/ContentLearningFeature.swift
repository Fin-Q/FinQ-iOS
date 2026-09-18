//
//  ContentLearningFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/16/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContentLearningFeature {
    @Dependency(\.knowledgeMapUseCase) private var knowledgeMapUseCase

    enum Phase: Equatable {
        case learning
        case answerResult
    }

    @ObservableState
    struct State: Equatable {
        let contentID: Int
        let categoryCode: String
        let isFirstLearning: Bool // 신규 사용자가 첫 학습 진행 여부(모든 카테고리 모든 콘텐츠 중 하나도 완료한게 없는 경우)
        let isHomeQuestionTarget: Bool
        var content: LearningContent?
        var currentBlockIndex: Int = 0
        var selectedOptionID: String?
        var answerResult: ContentAnswerResult?
        var phase: Phase = .learning
        var isLoading: Bool = false
        var isSubmittingAnswer: Bool = false
        var errorMessage: String?

        var currentBlock: LearningContentBlock? {
            guard let content, content.blocks.indices.contains(currentBlockIndex) else { return nil }
            return content.blocks[currentBlockIndex]
        }

        var currentQuestion: LearningQuestionBlock? {
            guard case let .question(question)? = currentBlock else { return nil }
            return question
        }

        var canMovePrevious: Bool { phase == .learning && currentBlockIndex > 0 && !isSubmittingAnswer }

        var isNextButtonEnabled: Bool {
            guard phase == .learning, !isLoading, !isSubmittingAnswer, let currentBlock else { return false }

            switch currentBlock {
            case .body:
                return content?.blocks.indices.contains(currentBlockIndex + 1) == true
            case .question:
                return selectedOptionID != nil
            }
        }

        var bodyBlockIndices: [Int] {
            guard let blocks = content?.blocks else { return [] }
            return blocks.indices.filter { index in
                if case .body = blocks[index] { return true }
                return false
            }
        }

        var totalBodyBlockCount: Int { bodyBlockIndices.count }
        var currentBodyBlockNumber: Int { bodyBlockIndices.filter { $0 <= currentBlockIndex }.count }

        var isProgressVisible: Bool {
            guard phase == .learning, case .body? = currentBlock else { return false }
            return true
        }

        var progress: Double {
            guard totalBodyBlockCount > 0 else { return 0 }
            return min(1, Double(currentBodyBlockNumber) / Double(totalBodyBlockCount))
        }
    }

    enum Action {
        case task
        case fetchSucceeded(LearningContent)
        case fetchFailed(String)
        case optionTapped(String)
        case previousButtonTapped
        case nextButtonTapped
        case submitAnswerSucceeded(ContentAnswerResult)
        case submitAnswerFailed(String)
        case answerResultButtonTapped
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case homeTapTargetLearningStartLogged(contentID: Int)
            case completionRequested(ContentCompletionResult?)
        }
    }

    private enum CancelID { case fetch, submitAnswer }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                guard state.content == nil, !state.isLoading else { return .none }
                let contentID = state.contentID
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let content = try await knowledgeMapUseCase.fetchContent(contentID: contentID)
                        guard !Task.isCancelled else { return }
                        await send(.fetchSucceeded(content))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetch, cancelInFlight: true)

            case let .fetchSucceeded(content):
                state.isLoading = false
                guard !content.blocks.isEmpty else {
                    state.errorMessage = "학습할 콘텐츠가 없어요."
                    return .none
                }
                state.content = content
                state.currentBlockIndex = 0
                state.selectedOptionID = nil
                state.answerResult = nil
                state.phase = .learning

                let firstLearningEffect: Effect<Action> = state.isFirstLearning ? .run { [contentID = state.contentID, categoryCode = state.categoryCode] _ in
                    await knowledgeMapUseCase.logFirstLearningStart(contentID: contentID, categoryCode: categoryCode)
                } : .none
                let homeTapTargetEffect: Effect<Action> = state.isHomeQuestionTarget ? .merge(
                    .send(.delegate(.homeTapTargetLearningStartLogged(contentID: state.contentID))),
                    .run { [contentID = state.contentID, categoryCode = state.categoryCode] _ in
                        await knowledgeMapUseCase.logHomeTapTargetLearningStart(contentID: contentID, categoryCode: categoryCode)
                    }
                ) : .none
                return .merge(firstLearningEffect, homeTapTargetEffect)

            case let .fetchFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case let .optionTapped(optionID):
                guard state.phase == .learning, !state.isSubmittingAnswer, state.currentQuestion?.options.contains(where: { $0.optionID == optionID }) == true else { return .none }
                state.selectedOptionID = optionID
                return .none

            case .previousButtonTapped:
                guard state.canMovePrevious else { return .none }
                state.currentBlockIndex -= 1
                state.selectedOptionID = nil
                return .none

            case .nextButtonTapped:
                guard state.isNextButtonEnabled, let currentBlock = state.currentBlock else { return .none }

                switch currentBlock {
                case .body:
                    state.currentBlockIndex += 1
                    state.selectedOptionID = nil
                    return .none

                case let .question(question):
                    guard let selectedOptionID = state.selectedOptionID else { return .none }
                    let contentID = state.contentID
                    state.isSubmittingAnswer = true
                    state.errorMessage = nil

                    return .run { send in
                        do {
                            let result = try await knowledgeMapUseCase.submitContentAnswer(contentID: contentID, questionID: question.questionID, selectedOptionID: selectedOptionID)
                            guard !Task.isCancelled else { return }
                            await send(.submitAnswerSucceeded(result))
                        } catch {
                            guard !Task.isCancelled else { return }
                            await send(.submitAnswerFailed(error.localizedDescription))
                        }
                    }
                    .cancellable(id: CancelID.submitAnswer, cancelInFlight: true)
                }

            case let .submitAnswerSucceeded(result):
                state.isSubmittingAnswer = false
                state.answerResult = result
                state.phase = .answerResult

                guard state.isFirstLearning, result.nextAction == .contentCompleted else { return .none }
                return .run { [contentID = state.contentID, categoryCode = state.categoryCode] _ in
                    await knowledgeMapUseCase.logFirstLearningComplete(contentID: contentID, categoryCode: categoryCode)
                }

            case let .submitAnswerFailed(message):
                state.isSubmittingAnswer = false
                state.errorMessage = message
                return .none

            case .answerResultButtonTapped:
                guard state.phase == .answerResult, let result = state.answerResult else { return .none }

                if !result.correct || result.nextAction == .retry {
                    state.answerResult = nil
                    state.selectedOptionID = nil
                    state.phase = .learning
                    return .none
                }

                switch result.nextAction {
                case .contentCompleted:
                    return .send(.delegate(.completionRequested(result.contentResult)))

                case .nextBody, .nextSummary, .nextQuestion:
                    guard state.content?.blocks.indices.contains(state.currentBlockIndex + 1) == true else {
                        state.errorMessage = "다음 학습 내용을 찾을 수 없어요."
                        return .none
                    }
                    state.currentBlockIndex += 1
                    state.answerResult = nil
                    state.selectedOptionID = nil
                    state.phase = .learning
                    return .none

                case .retry:
                    return .none
                }

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
