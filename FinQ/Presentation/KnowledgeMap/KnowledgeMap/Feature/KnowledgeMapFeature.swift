//
//  KnowledgeMapFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct KnowledgeMapFeature {
    @Dependency(\.knowledgeMapUseCase) private var knowledgeMapUseCase
    
    @Reducer
    enum Path {
        case mapDetail(MapDetailFeature)
        case advancedQuizMain(AdvancedQuizMainFeature)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var categories: [KnowledgeMapCategory] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case fetchCategoriesSucceeded([KnowledgeMapCategory])
        case fetchCategoriesFailed(String)
        case alertOKButtonTapped
        case categoryTapped(KnowledgeMapCategory)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    do {
                        let categories = try await knowledgeMapUseCase.fetchCategories()
                        guard !Task.isCancelled else { return }
                        await send(.fetchCategoriesSucceeded(categories))
                    } catch {
                        guard !Task.isCancelled else { return }
                        await send(.fetchCategoriesFailed(error.localizedDescription))
                    }
                }

            case let .fetchCategoriesSucceeded(categories):
                state.categories = categories
                state.isLoading = false
                return .none

            case let .fetchCategoriesFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case .alertOKButtonTapped:
                state.errorMessage = nil
                return .none
                
            case .categoryTapped(let category):
                state.path.append(.mapDetail(MapDetailFeature.State(category: category)))
                return .none

            case let .path(.element(id: id, action: .mapDetail(.delegate(.advancedQuizRequested(categoryID))))):
                guard state.path.ids.last == id else { return .none }
                state.path.append(.advancedQuizMain(AdvancedQuizMainFeature.State(categoryID: categoryID)))
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension KnowledgeMapFeature.Path.State: Equatable {}
