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
    @Reducer
    enum Path {
        case characterGuide(CharacterGuideFeature)
    }

    enum Topic: String, CaseIterable, Identifiable, Sendable {
        case salaryAndSaving
        case investmentBasics
        case stocksAndETF
        case taxSaving

        var id: Self { self }

        var title: String {
            switch self {
            case .salaryAndSaving: "월급관리·저축"
            case .investmentBasics: "투자 기초"
            case .stocksAndETF: "주식·ETF"
            case .taxSaving: "세금·절세계좌"
            }
        }
    }

    @ObservableState
    struct State: Equatable {
        var selectedTopics: Set<Topic> = []
        var path = StackState<Path.State>()

        var isNextButtonEnabled: Bool { selectedTopics.count == 2 }

        func isTopicSelectionDisabled(_ topic: Topic) -> Bool {
            selectedTopics.count >= 2 && !selectedTopics.contains(topic)
        }
    }
    
    enum Action {
        case topicTapped(Topic)
        case nextButtonTapped
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
                state.path.append(.characterGuide(CharacterGuideFeature.State()))
                return .none

            case let .path(.element(id: id, action: .characterGuide(.startButtonTapped))):
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
