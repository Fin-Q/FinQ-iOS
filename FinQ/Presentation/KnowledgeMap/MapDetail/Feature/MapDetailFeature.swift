//
//  MapDetailFeature.swift
//  FinQ
//
//  Created by 권대윤 on 9/13/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MapDetailFeature {
    @Dependency(\.knowledgeMapUseCase) private var knowledgeMapUseCase

    @ObservableState
    struct State: Equatable {
        let category: KnowledgeMapCategory
        var targetContentID: Int? = nil
        var detail: KnowledgeMapCategoryDetail?
        var isLoading: Bool = false
        var errorMessage: String?
        var isPremiumAlertPresented: Bool = false
    }
    
    enum Action {
        case onAppear
        case fetchDetailSucceeded(KnowledgeMapCategoryDetail)
        case fetchDetailFailed(String)
        case alertOKButtonTapped
        case challengeButtonTapped
        case contentCardTapped(Int)
        case premiumContentTapped(KnowledgeMapPremiumContent)
        case premiumAlertOKButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil

                return .run { [topic = state.category.topic] send in
                    do {
                        let detail = try await knowledgeMapUseCase.fetchCategoryDetail(topic: topic)
                        guard !Task.isCancelled else { return }
                        await send(.fetchDetailSucceeded(detail))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchDetailFailed(error.localizedDescription))
                    }
                }

            case let .fetchDetailSucceeded(detail):
                state.detail = detail
                state.isLoading = false
                return .none

            case let .fetchDetailFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none

            case let .premiumContentTapped(content):
                state.isPremiumAlertPresented = true

                return .run { [categoryCode = state.category.topic.rawValue] _ in
                    await knowledgeMapUseCase.logPremiumContentTapped(contentID: content.contentID, categoryCode: categoryCode)
                }

            case .premiumAlertOKButtonTapped:
                state.isPremiumAlertPresented = false
                return .none

            case .challengeButtonTapped, .contentCardTapped:
                return .none
            }
        }
    }
}
