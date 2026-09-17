//
//  MyPageInterestSelectionFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyPageInterestSelectionFeature {
    @Dependency(\.myPageUseCase) private var myPageUseCase

    @ObservableState
    struct State: Equatable {
        var selectedTopics: Set<InterestTopic>
        var isSaving: Bool = false
        var errorMessage: String?

        var isCompleteButtonEnabled: Bool { !selectedTopics.isEmpty && selectedTopics.count <= 2 && !isSaving }

        func isTopicSelectionDisabled(_ topic: InterestTopic) -> Bool {
            isSaving || (selectedTopics.count >= 2 && !selectedTopics.contains(topic))
        }
    }

    enum Action {
        case topicTapped(InterestTopic)
        case completeButtonTapped
        case updateInterestsSucceeded
        case updateInterestsFailed(String)
        case alertOKButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .topicTapped(topic):
                guard !state.isSaving else { return .none }

                if state.selectedTopics.contains(topic) {
                    state.selectedTopics.remove(topic)
                } else if state.selectedTopics.count < 2 {
                    state.selectedTopics.insert(topic)
                }
                return .none

            case .completeButtonTapped:
                guard state.isCompleteButtonEnabled else { return .none }
                let topics = state.selectedTopics.sorted { $0.id < $1.id }
                state.isSaving = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        try await myPageUseCase.updateInterests(topics: topics)
                        await send(.updateInterestsSucceeded)
                    } catch {
                        await send(.updateInterestsFailed(error.localizedDescription))
                    }
                }

            case .updateInterestsSucceeded:
                state.isSaving = false
                return .send(.delegate(.completed))

            case let .updateInterestsFailed(message):
                state.isSaving = false
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
