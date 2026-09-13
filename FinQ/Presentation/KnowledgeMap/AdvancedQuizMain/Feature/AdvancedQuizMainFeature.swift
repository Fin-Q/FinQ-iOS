//
//  AdvancedQuizMainFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/14/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AdvancedQuizMainFeature {
    @Dependency(\.knowledgeMapUseCase) private var knowledgeMapUseCase

    @ObservableState
    struct State: Equatable {
        let categoryID: Int
        var quiz: AdvancedQuiz?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        case onAppear
        case fetchAdvancedQuizSucceeded(AdvancedQuiz)
        case fetchAdvancedQuizFailed(String)
        case alertOKButtonTapped
        case challengeButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.quiz == nil, !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil

                return .run { [categoryID = state.categoryID] send in
                    do {
                        let quiz = try await knowledgeMapUseCase.fetchAdvancedQuiz(categoryID: categoryID)
                        guard !Task.isCancelled else { return }
                        await send(.fetchAdvancedQuizSucceeded(quiz))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchAdvancedQuizFailed(error.localizedDescription))
                    }
                }

            case let .fetchAdvancedQuizSucceeded(quiz):
                state.quiz = quiz
                state.isLoading = false
                return .none

            case let .fetchAdvancedQuizFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .challengeButtonTapped:
                return .none
            }
        }
    }
}
