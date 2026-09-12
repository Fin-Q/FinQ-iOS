//
//  TabBarFeature.swift
//  FinQ
//
//  Created by 권대윤 on 8/29/26.
//

import ComposableArchitecture

@Reducer
struct TabBarFeature {
    enum Tab: Hashable {
        case home
        case knowledgeMap
        case myPage
    }

    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home

        var knowledgeMap = KnowledgeMapFeature.State()
        var home = HomeFeature.State()
        var myPage = MyPageFeature.State()
    }

    enum Action {
        case selectedTabChanged(Tab)

        case knowledgeMap(KnowledgeMapFeature.Action)
        case home(HomeFeature.Action)
        case myPage(MyPageFeature.Action)
        
        case delegate(Delegate)
        enum Delegate {
            case logout
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.knowledgeMap, action: \.knowledgeMap) {
            KnowledgeMapFeature()
        }

        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }

        Scope(state: \.myPage, action: \.myPage) {
            MyPageFeature()
        }

        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none
                
            case .myPage(.delegate(.logoutSucceeded)):
                return .send(.delegate(.logout))

            case .knowledgeMap, .home, .myPage, .delegate:
                return .none
            }
        }
    }
}
