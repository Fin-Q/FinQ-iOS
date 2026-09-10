//
//  OnboardingFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    @Dependency(\.onboardingUseCase) private var onboardingUseCase

    @Reducer
    enum Path {
        case characterGuide(CharacterGuideFeature)
    }

    @ObservableState
    struct State: Equatable {
        var selectedTopics: Set<InterestTopic> = []
        var path = StackState<Path.State>()
        var isSavingInterests: Bool = false
        var interestSelectionErrorMessage: String?

        var isNextButtonEnabled: Bool { selectedTopics.count == 2 && !isSavingInterests }

        func isTopicSelectionDisabled(_ topic: InterestTopic) -> Bool {
            isSavingInterests || (selectedTopics.count >= 2 && !selectedTopics.contains(topic))
        }
    }
    
    enum Action {
        case topicTapped(InterestTopic)
        case nextButtonTapped
        case saveInterestsSucceeded
        case saveInterestsFailed(String)
        case alertOKButtonTapped
        case path(StackActionOf<Path>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case completed
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .topicTapped(topic):
                guard state.path.isEmpty else { return .none }

                if state.selectedTopics.contains(topic) {
                    state.selectedTopics.remove(topic)
                } else if state.selectedTopics.count < 2 {
                    state.selectedTopics.insert(topic)
                }
                return .none

            case .nextButtonTapped:
                guard state.isNextButtonEnabled, state.path.isEmpty else { return .none }

                let topics = state.selectedTopics.sorted { $0.id < $1.id }
                state.isSavingInterests = true
                state.interestSelectionErrorMessage = nil

                return .run { send in
                    do {
                        try await onboardingUseCase.saveInterests(topics: topics)
                        guard !Task.isCancelled else { return }
                        await send(.saveInterestsSucceeded)
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.saveInterestsFailed(error.localizedDescription))
                    }
                }

            case .saveInterestsSucceeded:
                state.isSavingInterests = false
                state.path.append(.characterGuide(CharacterGuideFeature.State()))
                return .none

            case let .saveInterestsFailed(message):
                state.isSavingInterests = false
                state.interestSelectionErrorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.interestSelectionErrorMessage = nil
                return .none

            case let .path(.element(id: id, action: .characterGuide(.delegate(.completed)))):
                guard state.path.ids.last == id else { return .none }
                return .send(.delegate(.completed))

            case .path, .delegate:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension OnboardingFeature.Path.State: Equatable {}

extension InterestTopic {
    var title: String {
        switch self {
        case .salaryAndSaving: "월급관리·저축"
        case .investmentBasics: "투자 기초"
        case .stocksAndETF: "주식·ETF"
        case .taxSaving: "세금·절세계좌"
        }
    }
}
