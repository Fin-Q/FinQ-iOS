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
        let isGuestMode: Bool
        let category: KnowledgeMapCategory
        var targetContentID: Int? = nil
        var homeQuestionTargetContentID: Int? = nil
        var detail: KnowledgeMapCategoryDetail?
        var isLoading: Bool = false
        var errorMessage: String?
        var isPremiumAlertPresented: Bool = false
        var isGuestAlertPresented: Bool = false
    }
    
    enum Action {
        case onAppear
        case fetchDetailSucceeded(KnowledgeMapCategoryDetail)
        case fetchDetailFailed(String)
        case targetContentScrollCompleted
        case alertOKButtonTapped
        case challengeButtonTapped
        case contentCardTapped(Int)
        case premiumContentTapped(KnowledgeMapPremiumContent)
        case premiumAlertOKButtonTapped
        case guestAlertPresentedChanged(Bool)
        case guestLoginButtonTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case loginRequested
            case contentRequested(contentID: Int, categoryCode: String, isHomeQuestionTarget: Bool)
            case advancedQuizRequested(categoryID: Int)
        }
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

            case .targetContentScrollCompleted:
                state.targetContentID = nil
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

            case .challengeButtonTapped:
                if state.isGuestMode {
                    state.isGuestAlertPresented = true
                    return .none
                }
                
                return .send(.delegate(.advancedQuizRequested(categoryID: state.category.categoryID)))

            case let .contentCardTapped(contentID):
                return .send(.delegate(.contentRequested(contentID: contentID, categoryCode: state.category.topic.rawValue, isHomeQuestionTarget: state.homeQuestionTargetContentID == contentID)))
                
            case .guestAlertPresentedChanged(let isPresented):
                state.isGuestAlertPresented = isPresented
                return .none
                
            case .guestLoginButtonTapped:
                guard state.isGuestMode else { return .none }
                return .send(.delegate(.loginRequested))

            case .delegate:
                return .none
            }
        }
    }
}
