//
//  CharacterGuideFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterGuideFeature {
    @Dependency(\.onboardingUseCase) private var onboardingUseCase

    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        case startButtonTapped
        case completeOnboardingSucceeded
        case completeOnboardingFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                guard !state.isLoading else { return .none }

                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await onboardingUseCase.completeOnboarding()
                        guard !Task.isCancelled else { return }
                        await send(.completeOnboardingSucceeded)
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.completeOnboardingFailed(error.localizedDescription))
                    }
                }

            case .completeOnboardingSucceeded:
                state.isLoading = false
                return .send(.delegate(.completed))

            case let .completeOnboardingFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
